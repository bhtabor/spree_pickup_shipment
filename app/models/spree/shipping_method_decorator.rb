Spree::ShippingMethod.class_eval do

  belongs_to :pickup_location, class_name: Spree::PickupLocation.to_s
  delegate :address, to: :pickup_location, prefix: true

  def pickupable?
    pickup_location_id.present?
  end

end
