Rails.application.routes.draw do
  resources :carts
  resources :addresses
  resources :orders, except: :create
  resources :products
  resources :categories
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
