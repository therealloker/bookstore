Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config  
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root 'home#index'
  match '/catalog', to: 'books#index', via: 'get'
  resources :books, only: [:index, :show]
  resources :order_items, only: [:create, :update, :destroy]
  resource :cart, only: [:show, :update]
  resources :reviews, only: :create

  scope '/settings' do
    get '/addresses', to: 'addresses#edit'
    resources :addresses, only: [:update]
    as :user do
      get 'privacy', to: 'devise/registrations#edit'
    end
  end
end
