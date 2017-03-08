Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users
  resources :users, only: [:index, :destroy]

  namespace :admin do
    root 'home#index'
    resources :users, except: [:show, :destroy]
  end
end
