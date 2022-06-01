# frozen_string_literal: true

Rails.application.routes.draw do
  # Defines the root path route ("/")
  root to: "invoices#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :categories
  resources :items, only: [:new, :create, :update, :destroy, :edit]
  resources :invoices
  resources :taxs_calculator, only: [:show] do
    collection do
      get "download/:id" => "taxs_calculator#download", as: "download"
    end
  end
end
