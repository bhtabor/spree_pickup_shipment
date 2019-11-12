module Spree

  class Timing < Spree::Base

    ##Associations
    belongs_to :pickup_location, required: true

    ##Validations
    validates :day_id, presence: true

  end

end
