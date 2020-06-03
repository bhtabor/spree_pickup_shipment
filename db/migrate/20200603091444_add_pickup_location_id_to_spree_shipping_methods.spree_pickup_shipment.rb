class AddPickupLocationIdToSpreeShippingMethods < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_shipping_methods, :pickup_location_id, :integer
    add_index :spree_shipping_methods, :pickup_location_id
  end
end
