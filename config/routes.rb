Rails.application.routes.draw do
  resources :carts
  resources :addresses
  resources :orders
  resources :products
  resources :categories
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'categories#index'
  post '/cart', to: 'carts#remove_item', as: 'remove_item'

end
