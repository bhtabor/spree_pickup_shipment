Spree::Core::Engine.add_routes do
  # Add your extension routes here
  namespace :admin do
    resources :pickup_locations
  end
  resources :pickup_locations, only: :index
end
