Rails.application.routes.draw do
  root "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"    #名前付きルートlogin_path
  post "/login", to: "sessions#create"   #名前付きルートlogin_path
  delete "/logout", to: "sessions#destroy"    #名前付きルートlogout_path
  resources :users
end
