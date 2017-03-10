Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users
  resources :users, only: [:index, :destroy]
  post 'users/send_regards/:id', to: 'users#send_regards', as: 'user_send_regards'

  namespace :admin do
    root 'home#index'
    resources :users, except: [:show, :destroy]
  end
end
