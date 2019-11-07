Spree::Order.class_eval do

  Spree::Order::SHIPMENT_STATES += %w(delivered)

  _validators.delete(:shipment_state)

  _validate_callbacks.each do |callback|
    if callback.raw_filter.respond_to? :attributes
      callback.raw_filter.attributes.delete :shipment_state
    end
  end

  validates :shipment_state,  inclusion:  { in: Spree::Order::SHIPMENT_STATES, allow_blank: true }

end
