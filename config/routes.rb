Rails.application.routes.draw do

  resources :dogs
  resources :professionals
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".


  # Home Page
  root :to => 'landing#index'

  # Auth Routes
  get 'auth/:provider/callback', to: 'sessions#handle_auth', as: 'auth_success'
  get 'auth/failure', to: 'sessions#handle_failure', as: 'auth_failure'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'signup', to: 'sessions#login', as: 'login'
  # get 'login', to: 'sessions#login', as: 'login'
  get 'home', to: 'home#feed'

  # get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'

  # User Routes
  resources :users do
    resources :dogs
  end
  
  post 'users/:id/edit', to: 'users#edit'

  # resources :users
  resources :events, :only => [:index, :new, :create, :edit, :update, :show, :destroy]

  resources :mixes, :only => [:index, :show] do
    collection do
      get :autocomplete
    end
  end
  
  resource :starred_dogs, only: [:create, :destroy]
  resources :users do
    member do
      get 'stars'
    end
  end
  
  #post 'register_as_professional', to: 'user#upgrade'
  post 'register_professional', to: 'professionals#upgrade'
  post 'professionals/new', to: 'professionals#create'
  #post 'join_professional', to: 'professionals#join'
  
  #resources :professionals
  
  # #Dog Routes
  # resources :dogs

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
