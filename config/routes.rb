# frozen_string_literal: true

Rails.application.routes.draw do
  # Defines the root path route ("/")
  root to: "items#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :categories
  resources :items
  resources :taxs_calculator, only: [:index]
end
