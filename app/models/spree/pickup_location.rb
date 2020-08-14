module Spree
  class PickupLocation < ::Spree::Base
    attr_accessor :open_day_ids, :open_day_ids_was

    has_many :timings, dependent: :destroy, class_name: 'Spree::Timing'

    belongs_to :state, class_name: 'Spree::State', optional: true
    belongs_to :country, class_name: 'Spree::Country'

    validates :start_time, :end_time, presence: true
    validates :name, presence: true, uniqueness: { allow_blank: true }
    validates :timings, presence: { message: 'is required. Please enter open days.' }
    validate :end_time_must_be_greater_than_start_time

    scope :active, -> { where(active: true) }

    before_validation :set_timings, if: :open_day_ids_changed?
    after_initialize :set_open_day_ids

    def state_text
      state.try(:abbr) || state.try(:name) || state_name
    end

    private

    def set_open_day_ids
      self.open_day_ids = self.open_day_ids_was = timings.map(&:day_id)
    end

    def set_timings
      self.timings.delete_all
      self.timings = (open_day_ids.map{|i| Timing.new(day_id: i)})
    end

    def end_time_must_be_greater_than_start_time
      if start_time && end_time && start_time >= end_time
        errors.add(:end_time, Spree.t(:greater_than_start_time))
      end
    end

    def open_day_ids_changed?
      self.open_day_ids -= [""]
      !((open_day_ids.length == open_day_ids_was.length) && (open_day_ids.map(&:to_i) - open_day_ids_was).length == 0)
    end

  end

end
