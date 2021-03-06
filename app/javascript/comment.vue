<template lang="pug">
  .thread-comment
    .thread-comment__author
      a.thread-comment__author-link(:href="comment.user.url" itempro="url")
        img.thread-comment__author-icon.a-user-icon(:src="comment.user.avatar_url" :title="comment.user.icon_title"  v-bind:class="userRole")
    .thread-comment__body.a-card(v-if="!editing")
      header.thread-comment__body-header
        h2.thread-comment__title
          a.thread-comment__title-link(:href="comment.user.url" itempro="url")
            | {{ comment.user.login_name }}
        time.thread-comment__created-at(:class="{'is-active': activating}" :datetime="commentableCreatedAt" pubdate="pubdate" @click="copyCommentURLToClipboard(comment.id)")
          | {{ updatedAt }}
      .thread-comment__description.js-target-blank.is-long-text(v-html="markdownDescription")
      reaction(
        v-bind:reactionable="comment",
        v-bind:currentUser="currentUser",
        v-bind:reactionableId="reactionableId")
      footer.card-footer(v-if="comment.user.id == currentUser.id || currentUser.role == 'admin'")
        .card-footer-actions
          ul.card-footer-actions__items
            li.card-footer-actions__item
              button.card-footer-actions__action.a-button.is-md.is-primary.is-block(@click="editComment")
                i.fas.fa-pen
                | 編集
            li.card-footer-actions__item
              button.card-footer-actions__action.a-button.is-md.is-danger.is-block(@click="deleteComment")
                i.fas.fa-trash-alt
                | 削除
    .thread-comment-form__form.a-card(v-show="editing")
      .thread-comment-form__tabs.js-tabs
        .thread-comment-form__tab.js-tabs__tab(v-bind:class="{'is-active': isActive('comment')}" @click="changeActiveTab('comment')")
          | コメント
        .thread-comment-form__tab.js-tabs__tab(v-bind:class="{'is-active': isActive('preview')}" @click="changeActiveTab('preview')")
          | プレビュー
      .thread-comment-form__markdown-parent.js-markdown-parent
        .thread-comment-form__markdown.js-tabs__content(v-bind:class="{'is-active': isActive('comment')}")
          markdown-textarea(v-model="description" :class="classCommentId" class="a-text-input js-warning-form thread-comment-form__textarea js-comment-markdown" name="comment[description]")
        .thread-comment-form__markdown.js-tabs__content(v-bind:class="{'is-active': isActive('preview')}")
          .js-preview.is-long-text.thread-comment-form__preview(v-html="markdownDescription")
      .thread-comment-form__actions
        .thread-comment-form__action
          button.a-button.is-md.is-warning.is-block(@click="updateComment" v-bind:disabled="!validation")
            | 保存する
        .thread-comment-form__action
          button.a-button.is-md.is-secondary.is-block(@click="cancel")
            | キャンセル
</template>
<script>
import Reaction from './reaction.vue'
import MarkdownTextarea from './markdown-textarea.vue'
import MarkdownIt from 'markdown-it'
import MarkdownItEmoji from 'markdown-it-emoji'
import MarkdownItMention from './packs/markdown-it-mention'
import Prism from 'prismjs/components/prism-core'
import Tribute from 'tributejs'
import TextareaAutocomplteEmoji from 'classes/textarea-autocomplte-emoji'
import TextareaAutocomplteMention from 'classes/textarea-autocomplte-mention'
import moment from 'moment'

import "prism_languages"
moment.locale('ja');

export default {
  props: ['comment', 'currentUser', 'availableEmojis'],
  components: {
    'reaction': Reaction,
    'markdown-textarea': MarkdownTextarea
  },
  data: () => {
    return {
      description: '',
      editing: false,
      isCopied: false,
      tab: 'comment',
      activating: false
    }
  },
  created: function() {
    this.description = this.comment.description;
  },
  mounted: function() {
    $('textarea').textareaAutoSize();
    const textareas = document.querySelectorAll(`.comment-id-${this.comment.id}`)
    const emoji = new TextareaAutocomplteEmoji()
    const mention = new TextareaAutocomplteMention()

    mention.fetchValues(json => {
      mention.values = json
      const collection = [emoji.params(), mention.params()]
      const tribute = new Tribute({ collection: collection })
      tribute.attach(textareas)
    })

    const commentAnchor = location.hash;
    if(commentAnchor) {
      this.$nextTick( () => {
        location.href = location.href;
      })
    }
  },
  methods: {
    token () {
      const meta = document.querySelector('meta[name="csrf-token"]')
      return meta ? meta.getAttribute('content') : ''
    },
    isActive: function(tab) {
      return this.tab == tab
    },
    changeActiveTab: function(tab) {
      this.tab = tab
    },
    cancel: function() {
      this.description = this.comment.description;
      this.editing = false;
    },
    editComment: function() {
      this.editing = true;
      this.$nextTick(function() {
        $(`.comment-id-${this.comment.id}`).trigger('input');
      })
    },
    updateComment: function() {
      if (this.description.length < 1) { return null }
      let params = {
        'comment': { 'description': this.description }
      }
      fetch(`/api/comments/${this.comment.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': this.token()
        },
        credentials: 'same-origin',
        redirect: 'manual',
        body: JSON.stringify(params)
      })
        .then(response => {
          this.editing = false;
        })
        .catch(error => {
          console.warn('Failed to parsing', error)
        })
    },
    deleteComment: function() {
      if (window.confirm('削除してよろしいですか？')) {
        this.$emit('delete', this.comment.id);
      }
    },
    copyCommentURLToClipboard(commentId) {
      const commentURL = location.href.split("#")[0] + "#comment_" + commentId;
      const textBox = document.createElement("textarea");
      textBox.setAttribute("type", "hidden");
      textBox.textContent = commentURL;
      document.body.appendChild(textBox);
      textBox.select();
      document.execCommand('copy');
      document.body.removeChild(textBox);
      this.activating = true;
      setTimeout(() => {this.activating = false}, 4000);
    }
  },
  computed: {
    markdownDescription: function() {
      const md = new MarkdownIt({
        html: true,
        breaks: true,
        linkify: true,
        langPrefix: 'language-',
        highlight: (str, lang) => {
          if (lang && Prism.languages[lang]) {
            try {
              return Prism.highlight(str, Prism.languages[lang], lang);
            } catch (__) {}
          }

          return '';
        }
      });
      md.use(MarkdownItEmoji).use(MarkdownItMention)
      return md.render(this.description);
    },
    commentableCreatedAt: function() {
      return moment(this.comment.commentable.created_at).format()
    },
    updatedAt: function() {
      return moment(this.comment.updated_at).format('YYYY年MM月DD日(dd) HH:mm')
    },
    userRole: function(){
      return `is-${this.comment.user.role}`
    },
    classCommentId: function() {
      return `comment-id-${this.comment.id}`
    },
    validation: function() {
      return this.description.length > 0
    },
    reactionableId: function() {
      return `Comment_${this.comment.id}`;
    }
  }
}
</script>
