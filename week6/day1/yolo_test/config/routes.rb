Rails.application.routes.draw do
  root 'static_pages#home', page: "home"
  get "static_pages/*page", to: "static_pages#show"
  get "message/:user_entry", to: "message#show"
end
