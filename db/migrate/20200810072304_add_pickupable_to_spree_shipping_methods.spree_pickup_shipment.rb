class AddPickupableToSpreeShippingMethods < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_shipping_methods, :pickupable_id, :integer
    add_column :spree_shipping_methods, :pickupable_type, :string

    add_index :spree_shipping_methods, [:pickupable_type, :pickupable_id], name: "index_spree_shipping_methods_on_pickupable"
  end
end
