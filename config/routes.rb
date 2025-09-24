Rails.application.routes.draw do
  devise_for :users
  root "entries#index"         # homepage = list of entries
  resources :entries           # RESTful routes for journal entries
  get "about", to: "pages#about"
end
