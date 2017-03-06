Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :destroy]
  root to: 'home#index'

  namespace :admin do
    root 'home#index'
  end
end
