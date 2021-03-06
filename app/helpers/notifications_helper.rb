# frozen_string_literal: true

module NotificationsHelper
  def notification_unreads_count_badge
    count = current_user.unread_notifications_count
    if count > 99
      "99+"
    else
      count.to_s
    end
  end
end
