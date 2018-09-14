Rails.application.routes.draw do
  resources :beers
  resources :breweries
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'breweries#index'
  get 'kaikki_bisset',  to: 'breweries#index'
  get 'ratings', to: 'ratings#index'
  get 'ratings/new', to:'ratings#new'
  post 'ratings', to:'ratings#create'
end

