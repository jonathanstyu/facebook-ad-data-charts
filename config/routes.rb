Rails.application.routes.draw do
  resources :users do
    resources :fb_accounts, only: [:new, :create, :show]  do
      get 'query'
    end
  end
  resources :funnels

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'static_pages#home'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
    resource :session, only: [:new, :create, :destroy]
    
    get '/login', to: 'sessions#new'
    
    get '/gauthorize', to: 'sessions#gauthorize'
    get '/googlecallback', to: 'sessions#google_callback'
    
    get '/fbauthorize', to: 'sessions#fbauthorize'
    get '/fb_callback', to: 'sessions#fb_callback'
    get '/fbtokenresponse', to: 'sessions#fb_tokenresponse'
    
    
    get '/views', to: 'users#gaviews_query'
    get '/analyze', to: 'analyze#analyze'
    
    post '/funnels/events', to: 'funnels#events'

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
