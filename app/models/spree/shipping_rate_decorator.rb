Spree::ShippingRate.class_eval do
  delegate :pickupable?, to: :shipping_method, prefix: true
end
