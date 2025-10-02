Rails.application.routes.draw do
  get "ai/test"
  devise_for :users
  root "entries#index"         # homepage = list of entries
  resources :entries           # RESTful routes for journal entries
  get "about", to: "pages#about"
  get "ai/test", to: "ai#test"
  get  "talk", to: "ai#talk"
  post "chat", to: "ai#chat"



end
