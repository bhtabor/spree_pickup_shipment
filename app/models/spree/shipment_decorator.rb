Spree::Shipment::FINALIZED_STATES = ['delivered', 'shipped', 'ready_for_pickup', 'shipped_for_pickup']
Spree::Shipment.class_eval do

  scope :delivered, -> { with_state('delivered') }
  scope :shipped_for_pickup, -> { with_state('shipped_for_pickup') }
  scope :ready_for_pickup, -> { with_state('ready_for_pickup') }

  state_machine do

    event :ship_for_pickup do
      transition from: [:ready, :canceled], to: :shipped_for_pickup, if: :pickup?
    end
    after_transition to: :shipped_for_pickup, do: :after_ship

    event :ready_for_pickup do
      transition from: [:ready, :canceled], to: :ready_for_pickup
      transition from: :shipped_for_pickup, to: :ready_for_pickup
    end
    after_transition from: [:ready, :canceled], to: :ready_for_pickup, do: :after_ship

    event :deliver do
      transition from: [:ready_for_pickup, :shipped], to: :delivered
    end

    after_transition from: :canceled, to: [:ready_for_pickup, :shipped_for_pickup], do: :after_resume
    after_transition to: :delivered, do: :update_order_shipment

  end

  def finalized?
    self.class::FINALIZED_STATES.include?(state)
  end

  def determine_state(order)
    return 'canceled' if order.canceled?
    return 'pending' unless order.can_ship?
    return 'pending' if inventory_units.any? &:backordered?
    return 'shipped' if shipped?
    return 'shipped_for_pickup' if shipped_for_pickup?
    return 'ready_for_pickup' if ready_for_pickup?
    return 'delivered' if delivered?
    order.paid? || Spree::Config[:auto_capture_on_dispatch] ? 'ready' : 'pending'
  end

  def selected_shipping_rate_id=(id)
    shipping_rates.update_all(selected: false)
    shipping_rates.update(id, selected: true)
    if selected_shipping_rate.shipping_method_pickupable?
      self.address_id = selected_shipping_rate.pickup_location_address.id
      self.pickup = true
    else
      self.address_id = order.ship_address_id if order.present?
      self.pickup = false
    end
    save!
  end

  private

  def update_order_shipment
    Spree::ShipmentHandler.factory(self).send :update_order_shipment_state
  end

end
