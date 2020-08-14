module SpreePickupShipment::ShippingRateDecorator
  def self.prepended(base)
    base.delegate :pickupable?, to: :shipping_method, prefix: true
  end
end

::Spree::ShippingRate.prepend(SpreePickupShipment::ShippingRateDecorator)
