Deface::Override.new(
  virtual_path: 'spree/admin/shipping_methods/_form',
  name: 'add_pickup_location_in_shipping_method',
  insert_after: '[data-hook="admin_shipping_method_form_calculator_fields"]',
  text: '<div class="col-xs-12 col-md-6">
          <div class="panel panel-default">
            <div class="panel-heading">
              <h1 class="panel-title">
                <%= Spree.t(:pickup_location) %>
              </h1>
            </div>

            <div class="panel-body">
              <%= f.select :pickup_location_id, @pickup_locations.map { |pl| [ pl.name, pl.id ] }, { include_blank: true }, { class: "select2" } %>
            </div>
          </div>
        </div>
        '
)
