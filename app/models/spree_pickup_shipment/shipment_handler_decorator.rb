module SpreePickupShipment::ShipmentHandlerDecorator
  def ready_for_pickup(instant: false)
    if instant
       @shipment.inventory_units.each &:ship!
       @shipment.process_order_payments if ::Spree::Config[:auto_capture_on_dispatch]
    end
    @shipment.touch :ready_for_pickup_at
    update_order_shipment_state
    send_ready_for_pickup_email
  end

  def delivered
    @shipment.touch :delivered_at
    update_order_shipment_state
    send_delivered_email
  end

  private

  def send_ready_for_pickup_email
    ::Spree::ShipmentMailer.ready_for_pickup_email(@shipment.id).deliver_later
  end

  def send_delivered_email
    ::Spree::ShipmentMailer.delivered_email(@shipment.id).deliver_later
  end

end

::Spree::ShipmentHandler.prepend(SpreePickupShipment::ShipmentHandlerDecorator)
