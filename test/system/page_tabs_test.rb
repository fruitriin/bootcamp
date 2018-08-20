require "application_system_test_case"

class PageTabsTest < ApplicationSystemTestCase
  test "when login user is admin, practices tab members are practice and reports and products" do
    login_user "machida", "testtest"

    assert_text "プラクティス"
    click_link "プラクティス"
    first(".category-practices-item__title-link").click

    assert_text "終了条件"
    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "プラクティス"

    page_tabs = all(".page-tabs__item-link")
    assert_equal page_tabs.size, 3
    assert_equal page_tabs[0].text, "プラクティス"
    assert_equal page_tabs[1].text, "日報"
    assert_equal page_tabs[2].text, "提出物"

    practice_id = current_path.split("/").last.to_i

    all(".page-tabs__item-link")[0].click

    assert_text "終了条件"
    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "プラクティス"

    all(".page-tabs__item-link")[1].click

    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "日報"
    expected_report_counts = Practice.find(practice_id).reports.size
    actual_report_counts = all(".thread-list-item__title-link").size
    assert_equal actual_report_counts, expected_report_counts

    all(".page-tabs__item-link")[2].click

    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "提出物"
    expected_products_counts = Practice.find(practice_id).products.size
    actual_products_counts = all(".thread-list-item__title-link").size
    assert_equal actual_products_counts, expected_products_counts
  end

  test "when login user is adviser, practices tab members are practice and reports and products" do
    login_user "mineo", "testtest"

    assert_text "プラクティス"
    click_link "プラクティス"
    first(".category-practices-item__title-link").click

    assert_text "終了条件"
    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "プラクティス"

    page_tabs = all(".page-tabs__item-link")
    assert_equal page_tabs.size, 3
    assert_equal page_tabs[0].text, "プラクティス"
    assert_equal page_tabs[1].text, "日報"
    assert_equal page_tabs[2].text, "提出物"

    practice_id = current_path.split("/").last.to_i

    all(".page-tabs__item-link")[0].click

    assert_text "終了条件"
    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "プラクティス"

    all(".page-tabs__item-link")[1].click

    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "日報"
    expected_report_counts = Practice.find(practice_id).reports.size
    actual_report_counts = all(".thread-list-item__title-link").size
    assert_equal actual_report_counts, expected_report_counts

    all(".page-tabs__item-link")[2].click

    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "提出物"
    expected_products_counts = Practice.find(practice_id).products.size
    actual_products_counts = all(".thread-list-item__title-link").size
    assert_equal actual_products_counts, expected_products_counts
  end

  test "when login user is student and has a checked product, practices tab members are practice and reports and products" do
    login_user "yamada", "testtest"

    assert_text "プラクティス"
    click_link "プラクティス"
    all(".category-practices-item__title-link")[1].click

    assert_text "終了条件"
    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "プラクティス"

    page_tabs = all(".page-tabs__item-link")
    assert_equal page_tabs.size, 3
    assert_equal page_tabs[0].text, "プラクティス"
    assert_equal page_tabs[1].text, "日報"
    assert_equal page_tabs[2].text, "提出物"

    practice_id = current_path.split("/").last.to_i

    all(".page-tabs__item-link")[0].click

    assert_text "終了条件"
    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "プラクティス"

    all(".page-tabs__item-link")[1].click

    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "日報"
    expected_report_counts = Practice.find(practice_id).reports.size
    actual_report_counts = all(".thread-list-item__title-link").size
    assert_equal actual_report_counts, expected_report_counts

    all(".page-tabs__item-link")[2].click

    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "提出物"
    expected_products_counts = Practice.find(practice_id).products.size
    actual_products_counts = all(".thread-list-item__title-link").size
    assert_equal actual_products_counts, expected_products_counts
  end

  test "when login user is student and doesn't have a checked product, practices tab members are practice and reports" do
    login_user "kimura", "testtest"

    assert_text "プラクティス"
    click_link "プラクティス"
    first(".category-practices-item__title-link").click

    assert_text "終了条件"
    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "プラクティス"

    page_tabs = all(".page-tabs__item-link")
    assert_equal page_tabs.size, 2
    assert_equal page_tabs[0].text, "プラクティス"
    assert_equal page_tabs[1].text, "日報"

    practice_id = current_path.split("/").last.to_i

    all(".page-tabs__item-link")[0].click

    assert_text "終了条件"
    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "プラクティス"

    all(".page-tabs__item-link")[1].click

    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "日報"
    expected_report_counts = Practice.find(practice_id).reports.size
    actual_report_counts = all(".thread-list-item__title-link").size
    assert_equal actual_report_counts, expected_report_counts
  end

  test "when login user is admin, users tab members are user and practices and reports and products" do
    login_user "machida", "testtest"

    assert_text "ユーザー"
    click_link "ユーザー"

    last_displayed_student = all(".users-item__name-link").last
    assert_equal last_displayed_student.text, "kimura"
    last_displayed_student.click

    assert_text "Kimura Tadasi"
    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "ユーザー"

    page_tabs = all(".page-tabs__item-link")
    assert_equal page_tabs.size, 4
    assert_equal page_tabs[0].text, "ユーザー"
    assert_equal page_tabs[1].text, "プラクティス"
    assert_equal page_tabs[2].text, "日報"
    assert_equal page_tabs[3].text, "提出物"

    user_id = current_path.split("/").last.to_i

    all(".page-tabs__item-link")[0].click

    assert_text "Kimura Tadasi"
    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "ユーザー"

    all(".page-tabs__item-link")[1].click

    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "プラクティス"
    assert_text "完了したプラクティス"

    all(".page-tabs__item-link")[2].click

    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "日報"
    expected_report_counts = User.find(user_id).reports.size
    actual_report_counts = all(".thread-list-item__title-link").size
    assert_equal actual_report_counts, expected_report_counts

    all(".page-tabs__item-link")[3].click

    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "提出物"
    expected_products_counts = User.find(user_id).products.size
    actual_products_counts = all(".thread-list-item__title-link").size
    assert_equal actual_products_counts, expected_products_counts
  end

  test "when login user is adviser, users tab members are user and practices and reports and products" do
    login_user "mineo", "testtest"

    assert_text "ユーザー"
    click_link "ユーザー"

    last_displayed_student = all(".users-item__name-link").last
    assert_equal last_displayed_student.text, "kimura"
    last_displayed_student.click

    assert_text "Kimura Tadasi"
    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "ユーザー"

    page_tabs = all(".page-tabs__item-link")
    assert_equal page_tabs.size, 4
    assert_equal page_tabs[0].text, "ユーザー"
    assert_equal page_tabs[1].text, "プラクティス"
    assert_equal page_tabs[2].text, "日報"
    assert_equal page_tabs[3].text, "提出物"

    user_id = current_path.split("/").last.to_i

    all(".page-tabs__item-link")[0].click

    assert_text "Kimura Tadasi"
    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "ユーザー"

    all(".page-tabs__item-link")[1].click

    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "プラクティス"
    assert_text "完了したプラクティス"

    all(".page-tabs__item-link")[2].click

    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "日報"
    expected_report_counts = User.find(user_id).reports.size
    actual_report_counts = all(".thread-list-item__title-link").size
    assert_equal actual_report_counts, expected_report_counts

    all(".page-tabs__item-link")[3].click

    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "提出物"
    expected_products_counts = User.find(user_id).products.size
    actual_products_counts = all(".thread-list-item__title-link").size
    assert_equal actual_products_counts, expected_products_counts
  end

  test "when login user is student and target user has a checked product, users tab members are user and practices and reports and products" do
    login_user "kimura", "testtest"

    assert_text "ユーザー"
    click_link "ユーザー"

    last_displayed_student = all(".users-item__name-link").last
    assert_equal last_displayed_student.text, "yamada"
    last_displayed_student.click

    assert_text "Yamada Taro"
    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "ユーザー"

    page_tabs = all(".page-tabs__item-link")
    assert_equal page_tabs.size, 4
    assert_equal page_tabs[0].text, "ユーザー"
    assert_equal page_tabs[1].text, "プラクティス"
    assert_equal page_tabs[2].text, "日報"
    assert_equal page_tabs[3].text, "提出物"

    user_id = current_path.split("/").last.to_i

    all(".page-tabs__item-link")[0].click

    assert_text "Yamada Taro"
    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "ユーザー"

    all(".page-tabs__item-link")[1].click

    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "プラクティス"
    assert_text "完了したプラクティス"

    all(".page-tabs__item-link")[2].click

    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "日報"
    expected_report_counts = User.find(user_id).reports.size
    actual_report_counts = all(".thread-list-item__title-link").size
    assert_equal actual_report_counts, expected_report_counts

    all(".page-tabs__item-link")[3].click

    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "提出物"
    expected_products_counts = User.find(user_id).products.map(&:checked?).size
    actual_products_counts = all(".thread-list-item__title-link").size
    assert_equal actual_products_counts, expected_products_counts
  end

  test "when login user is student and target user doesn't have a checked product, users tab members are user and practices and reports" do
    login_user "yamada", "testtest"

    assert_text "ユーザー"
    click_link "ユーザー"

    last_displayed_student = all(".users-item__name-link").last
    assert_equal last_displayed_student.text, "kimura"
    last_displayed_student.click

    assert_text "Kimura Tadasi"
    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "ユーザー"

    page_tabs = all(".page-tabs__item-link")
    assert_equal page_tabs.size, 3
    assert_equal page_tabs[0].text, "ユーザー"
    assert_equal page_tabs[1].text, "プラクティス"
    assert_equal page_tabs[2].text, "日報"

    user_id = current_path.split("/").last.to_i

    all(".page-tabs__item-link")[0].click

    assert_text "Kimura Tadasi"
    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "ユーザー"

    all(".page-tabs__item-link")[1].click

    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "プラクティス"
    assert_text "完了したプラクティス"

    all(".page-tabs__item-link")[2].click

    assert_equal all(".is-current").length, 1
    assert_equal first(".is-current").text, "日報"
    expected_report_counts = User.find(user_id).reports.size
    actual_report_counts = all(".thread-list-item__title-link").size
    assert_equal actual_report_counts, expected_report_counts
  end
end