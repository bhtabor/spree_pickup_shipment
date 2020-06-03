module Spree
  class Timing < ::Spree::Base
    belongs_to :pickup_location, required: true

    validates :day_id, presence: true
  end
end
