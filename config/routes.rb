Rails.application.routes.draw do
  root to: "price_lists#new"

  resources :price_lists, only: %i[new create]
end
