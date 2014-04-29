Rails.application.routes.draw do
  match 'users/sign_in', to: "sessions#new", via: :get
  match 'users/sign_in', to: "sessions#login_step_1", via: :post
  match 'users/sign_in_step_2', to: "sessions#coords", via: :get
  match 'users/sign_in_step_2', to: "sessions#login_step_2", via: :post  
  match "users/sign_out", to: "sessions#destroy", via: :delete
  match "users/new", to: "users#new", via: :get
  match "users/confirm", to: "users#confirm", via: :get
  match "users/clean", to: "users#clean", via: :get
  match "users", to: "users#create", via: :post

  
  get 'pages/index'  

  root 'pages#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
