IHealth::Application.routes.draw do
  require 'api'
  mount IHealth::API => '/'
end
