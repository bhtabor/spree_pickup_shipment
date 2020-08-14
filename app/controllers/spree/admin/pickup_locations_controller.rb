module Spree
  module Admin
    class PickupLocationsController < ResourceController
      before_action :set_country, only: :new

      private

      def set_country
        @pickup_location.country = Spree::Country.default
        unless @pickup_location.country
          flash[:error] = Spree.t(:pickup_locations_need_a_default_country)
          redirect_to admin_pickup_locations_path
        end
      end
    end
  end
end
