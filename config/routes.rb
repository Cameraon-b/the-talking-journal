Rails.application.routes.draw do
  devise_for :users

  # Journal entries
  resources :entries

  # Conversations (for AI chat history)
  resources :conversations, only: [:create, :destroy]

  # Static pages
  get "about", to: "pages#about"

  # AI routes
  get  "talk", to: "ai#talk", as: :talk
  post "chat", to: "ai#chat", as: :chat

  # Root path
  root "entries#index"
end

