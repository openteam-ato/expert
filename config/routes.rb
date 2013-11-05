Expert::Application.routes.draw do
  mount ElVfsClient::Engine => '/'
  get '/(*path)', :to => 'main#index'
end
