# frozen_string_literal: true

Rails.application.routes.draw do
  get "taxs_calculator/index"
  get "tax_calculator/index"
  # Defines the root path route ("/")
  root to: "items#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :taxes
  resources :items
end
