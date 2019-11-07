class AddPickupToSpreeShipments < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_shipments, :pickup, :boolean, default: false
  end
end
