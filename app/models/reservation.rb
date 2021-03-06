# frozen_string_literal: true

class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :seat

  validates :seat_id, uniqueness: { scope: :date }
  validate :after_a_month
  validate :maximum_reservations, unless: :admin_or_trainee?

  private
    def after_a_month
      if date > (Date.today.next_month)
        errors.add(:date, "は一ヶ月先までしか予約できません")
      end
    end

    def maximum_reservations(threshold = 5)
      if date > Date.today && count_reservations >= threshold
        errors.add(:base, "明日以降の座席は最大#{threshold}つまでしか予約できません")
      end
    end

    def admin_or_trainee?
      user.admin? || user.trainee?
    end

    def count_reservations
      user.reservations.count { |reservation| reservation.date > Date.today }
    end
end
