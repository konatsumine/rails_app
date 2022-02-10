Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :show]
  resources :relationships, only: [:create, :destroy]
  resources :messages, only: [:create]
  resources :rooms, :only => [:create, :show, :index]

  root 'posts#index'
  get 'posts/new' => 'posts#new'
  get 'home/index' => 'home#index'

  post 'posts/create' => 'posts#create'
  patch 'posts/:id' => 'posts#update'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :posts do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create]
  end


end
