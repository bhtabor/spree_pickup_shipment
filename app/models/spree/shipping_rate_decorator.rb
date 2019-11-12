Spree::ShippingRate.class_eval do
  delegate :pickupable?, to: :shipping_method, prefix: true
  delegate :pickup_location_address, to: :shipping_method, allow_nil: true
end
