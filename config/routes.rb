Spree::Core::Engine.routes.append do
  # Add your extension routes here
  namespace :admin do
    resources :additional_calculator_rates, :only => [ :index, :edit, :update ]
  end
end
