class AddPickupDetailsToSpreeShipments < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_shipments, :pickup, :boolean, default: false
    add_column :spree_shipments, :ready_for_pickup_at, :datetime
    add_column :spree_shipments, :delivered_at, :datetime
  end
end
