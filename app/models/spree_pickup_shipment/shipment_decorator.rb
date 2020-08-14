Spree::Shipment::FINALIZED_STATES = ['delivered', 'shipped', 'ready_for_pickup', 'shipped_for_pickup']

module SpreePickupShipment::ShipmentDecorator
  def self.prepended(base)
    base.scope :delivered, -> { with_state('delivered') }
    base.scope :shipped_for_pickup, -> { with_state('shipped_for_pickup') }
    base.scope :ready_for_pickup, -> { with_state('ready_for_pickup') }

    base.state_machine do
      event :ship_for_pickup do
        transition from: [:ready, :canceled], to: :shipped_for_pickup, if: :pickup?
      end
      after_transition to: :shipped_for_pickup, do: :after_ship

      event :ready_for_pickup do
        transition from: [:ready, :canceled], to: :ready_for_pickup, if: :pickup?
        transition from: :shipped_for_pickup, to: :ready_for_pickup
      end
      after_transition from: [:ready, :canceled], to: :ready_for_pickup, do: :after_instant_ready_for_pickup
      after_transition from: :shipped_for_pickup, to: :ready_for_pickup, do: :after_ready_for_pickup

      event :deliver do
        transition from: [:ready_for_pickup, :shipped], to: :delivered
      end

      after_transition from: :canceled, to: [:ready_for_pickup, :shipped_for_pickup], do: :after_resume
      after_transition to: :delivered, do: :after_delivered
    end
  end

  def finalized?
    Spree::Shipment::FINALIZED_STATES.include?(state)
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
    self.pickup = selected_shipping_rate.shipping_method_pickupable?
    save!
  end

  def stock_pickup?
    pickup? && stock_location == selected_shipping_rate.shipping_method.pickupable
  end

  private

  def after_ready_for_pickup
    Spree::ShipmentHandler.factory(self).ready_for_pickup
  end

  def after_instant_ready_for_pickup
    Spree::ShipmentHandler.factory(self).ready_for_pickup(instant: true)
  end

  def after_delivered
    Spree::ShipmentHandler.factory(self).delivered
  end

end

::Spree::Shipment.prepend(SpreePickupShipment::ShipmentDecorator)
