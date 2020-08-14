module SpreePickupShipment::ShippingMethodDecorator
  def self.prepended(base)
    base.attr_accessor :pickup, :pickup_was
    base.belongs_to :pickupable, polymorphic: true, required: false

    base.before_validation :set_pickupable, if: :pickup_changed?
    base.after_initialize :set_pickup
  end

  def pickupable?
    pickupable.present?
  end

  private

  def set_pickup
    self.pickup = "#{pickupable.class.to_s}-#{pickupable.id}" if pickupable?
  end

  def set_pickupable
    if pickup.blank?
      self.pickupable_id = nil
      self.pickupable_type = nil
    else
      self.pickupable_id = pickup.split("-").last.to_i
      self.pickupable_type = pickup.split("-").first
    end
  end

  def pickup_changed?
    pickup != pickup_was
  end

end

::Spree::ShippingMethod.prepend(SpreePickupShipment::ShippingMethodDecorator)
