module Spree::Admin::ShippingMethodsControllerDecorator
  private

  def load_data
    @available_zones = Spree::Zone.order(:name)
    @tax_categories = Spree::TaxCategory.order(:name)
    @calculators = Spree::ShippingMethod.calculators.sort_by(&:name)
    @pickup_locations = Spree::PickupLocation.order(:name)
  end
end

Spree::Admin::PickupLocationsController.prepend Spree::Admin::PickupLocationsControllerDecorator
