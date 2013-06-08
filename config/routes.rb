IHealth::Application.routes.draw do
  resources :home
  
  root to: 'home#index'

  require 'api'
  mount IHealth::API => '/'
end
