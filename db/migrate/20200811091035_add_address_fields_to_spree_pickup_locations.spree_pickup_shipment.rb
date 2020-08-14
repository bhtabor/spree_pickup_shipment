class AddAddressFieldsToSpreePickupLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_pickup_locations, :address1, :string
    add_column :spree_pickup_locations, :address2, :string
    add_column :spree_pickup_locations, :city, :string
    add_column :spree_pickup_locations, :state_id, :integer
    add_column :spree_pickup_locations, :state_name, :string
    add_column :spree_pickup_locations, :country_id, :integer
    add_column :spree_pickup_locations, :zipcode, :string
    add_column :spree_pickup_locations, :phone, :string
  end
end
