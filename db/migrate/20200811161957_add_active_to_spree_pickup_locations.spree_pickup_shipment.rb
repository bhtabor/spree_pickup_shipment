class AddActiveToSpreePickupLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_pickup_locations, :active, :boolean, default: true
  end
end
