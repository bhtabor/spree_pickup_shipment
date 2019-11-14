class AddReadyForPickupAtAndDeliveredAtToSpreeShipments < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_shipments, :ready_for_pickup_at, :datetime
    add_column :spree_shipments, :delivered_at, :datetime
  end
end
