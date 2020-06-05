Deface::Override.new(
  virtual_path: 'spree/admin/shipping_methods/_form',
  name: 'add_pickup_location_in_shipping_method',
  insert_after: '[data-hook="admin_shipping_method_form_calculator_fields"]',
  text: '<div class="col-12 col-lg-6">
          <div class="card mb-3">
            <div class="card-header">
              <h1 class="card-title mb-0 h5">
                <%= Spree.t(:pickup_location) %>
              </h1>
            </div>

            <div class="card-body">
              <%= f.select :pickup_location_id, @pickup_locations.map { |pl| [ pl.name, pl.id ] }, { include_blank: true }, { class: "select2" } %>
            </div>
          </div>
        </div>
        '
)
