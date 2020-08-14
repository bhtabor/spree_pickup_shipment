class AddAdminNameToSpreePickupLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_pickup_locations, :admin_name, :string
  end
end
