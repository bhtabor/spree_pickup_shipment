Spree::Order::SHIPMENT_STATES += %w(shipped_for_pickup ready_for_pickup delivered)

module SpreePickupShipment::OrderDecorator
  def self.prepended(base)
    base._validators.delete(:shipment_state)

    base._validate_callbacks.each do |callback|
      if callback.raw_filter.respond_to? :attributes
        callback.raw_filter.attributes.delete :shipment_state
      end
    end

    base.validates :shipment_state,  inclusion:  { in: Spree::Order::SHIPMENT_STATES, allow_blank: true }
  end

end

::Spree::Order.prepend(SpreePickupShipment::OrderDecorator)
