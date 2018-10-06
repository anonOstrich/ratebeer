Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'breweries#index'
  get 'kaikki_bisset',  to: 'breweries#index'
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  post 'places', to: 'places#search'
  delete 'signout', to: 'sessions#destroy'
 resources :ratings, only: [:index, :new, :create, :destroy]
 resource :session, only: [:new, :create, :destroy]
 resources :places, only: [:index, :show]

end

