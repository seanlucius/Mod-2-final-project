Rails.application.routes.draw do
  resources :carts
  resources :addresses
  resources :orders
  resources :products
  resources :categories
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/cart', to: 'carts#remove_item', as: 'remove_item'

root 'static_pages#home'
get '/signup', to: 'users#new'
get '/login', to: 'sessions#new'
post '/login', to: 'sessions#create'
delete '/logout', to: 'sessions#destroy'

resources :users

end
