class CreateSpreePickupLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :spree_pickup_locations do |t|
      t.string   :name
      t.integer  :address_id, index: true
      t.time     :start_time
      t.time     :end_time
      t.timestamps
    end
  end
end
