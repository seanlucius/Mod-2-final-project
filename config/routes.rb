Rails.application.routes.draw do
  resources :addresses
  resources :orders
  resources :products
  resources :categories

  post '/orders/:id', to: 'orders#add', as: 'add'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
