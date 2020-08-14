Deface::Override.new(
  virtual_path: 'spree/admin/orders/_shipment',
  name: 'add_ship_condition',
  replace: '[data-hook="stock-location"]',
  text: '
  <div class="card-header stock-location no-borderb" data-hook="stock-location">
    <h1 class="flex-wrap align-items-center card-title mb-0 h5">
      <span class="shipment-number"><%= shipment.number %></span>
      -
      <span class="shipment-state"><%= Spree.t("shipment_states.#{shipment.state}") %></span>
      <%= Spree.t(:package_from) %>
      <strong class="stock-location-name" data-hook="stock-location-name">\'<%= shipment.stock_location.name %>\'</strong>

      <% if (shipment.ready? && can?(:update, shipment)) %>
        <% if shipment.pickup? %>
          <%= link_to "Ship for Pickup", "javascript:;", class: "pickup_ship btn-sm ml-auto btn btn-success", data: { "shipment-number"=> shipment.number } unless shipment.stock_pickup? %>
        <% else %>
          <%= link_to Spree.t(:ship), "javascript:;", class: "ship ml-auto btn-sm btn btn-success", data: { "shipment-number"=> shipment.number } %>
          <div class="clearfix"></div>
        <% end %>
      <% end %>

      <% if(shipment.pickup? && (shipment.shipped_for_pickup? || shipment.ready?) && can?(:update, shipment)) %>
        <%= link_to "Ready for Pickup", "javascript:;", class: "pickup_ready ml-auto btn-sm btn btn-success", data: { "shipment-number"=> shipment.number } %>
        <div class="clearfix"></div>
      <% end %>

      <% if((shipment.shipped? || shipment.ready_for_pickup?) && shipment.inventory_units.where.not(state: "returned").any? and can?(:update, shipment)) %>
        <%= link_to "Deliver", "javascript:;", class: "deliver ml-auto btn btn-sm btn-success", data: { "shipment-number"=> shipment.number } %>
        <div class="clearfix"></div>
      <% end %>
    </h1>
  </div>
  '
)
