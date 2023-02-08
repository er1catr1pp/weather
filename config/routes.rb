Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "weather_summaries#new"

  resources :weather_summaries, only: [:new, :create, :index]
end
