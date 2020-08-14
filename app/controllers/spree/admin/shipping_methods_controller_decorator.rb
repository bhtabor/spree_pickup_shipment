module Spree::Admin::ShippingMethodsControllerDecorator
  private

  def load_data
    super
    @pickup_locations = Spree::PickupLocation.active.order(:name)
    @stock_locations = Spree::StockLocation.active.order(:name)
  end
end

Spree::Admin::ShippingMethodsController.prepend Spree::Admin::ShippingMethodsControllerDecorator
