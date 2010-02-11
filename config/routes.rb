Stardate::Application.routes.draw do |map|
  
  resources :images
  resources :items
  resources :notes
  resources :recurrings
  resources :reports
  resources :runs
  resources :sessions
  resources :tags
  resources :things
  resources :users
  resources :vendors
  
  match 'date/:year/:month/:day'=>'date#show', :as=>:date, :requirements=>{:year=>/(19|20)\d\d/, :month=>/[01]?\d/, :day=>/[0-3]?\d/}

  match 'graphs/running/:start/:finish.:format'=>'graphs#running', :as=>:running
  match 'graphs/spending/:start/:finish.:format'=>'graphs#spending', :as=>:spending
  
  root :to=>'things#index'
  
end
