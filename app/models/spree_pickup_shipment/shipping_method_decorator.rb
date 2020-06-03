module SpreePickupShipment::ShippingMethodDecorator
  def self.prepended(base)
    base.belongs_to :pickup_location, class_name: Spree::PickupLocation.to_s, required: false
    base.delegate :address, to: :pickup_location, prefix: true, allow_nil: true
  end

  def pickupable?
    pickup_location_id.present?
  end

end

::Spree::ShippingMethod.prepend(SpreePickupShipment::ShippingMethodDecorator)
