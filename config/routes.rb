Expert::Application.routes.draw do
  mount ElVfsClient::Engine => '/'

  get  'ru/interaktiv' => 'requests#new',    :as => :new_request
  post 'ru/interaktiv' => 'requests#create', :as => :create_request

  get '/(*path)', :to => 'main#index'
end
