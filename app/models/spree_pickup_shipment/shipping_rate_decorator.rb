module SpreePickupShipment::ShippingRateDecorator
  def self.prepended(base)
    base.delegate :pickupable?, to: :shipping_method, prefix: true
    base.delegate :pickup_location_address, to: :shipping_method, allow_nil: true
  end
end

::Spree::ShippingRate.prepend(SpreePickupShipment::ShippingRateDecorator)
