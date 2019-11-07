Spree::Core::Engine.add_routes do
  # Add your extension routes here
  namespace :admin do
    resources :pickup_locations
  end
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      get 'pickup_locations/search', to: 'pickup_locations#search', as: :pickup_locations_search
      resources :shipments, only: [:create, :update] do
        member do
          put :deliver
          put :ready_for_pickup
          put :ship_for_pickup
        end
      end
    end
  end
  resources :pickup_locations, only: :index
end
