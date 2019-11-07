class AddPickupLocationIdToSpreeShippingMethods < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_shipping_methods, :pickup_location_id, :integer
    add_index :spree_shipping_methods, :pickup_location_id
  end
end
