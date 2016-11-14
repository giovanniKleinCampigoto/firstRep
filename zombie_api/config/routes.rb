Rails.application.routes.draw do
  get 'stats', to: "stats#index"

  resources :inventories, only: [:index]
  
  resources :survivors, except: [:new,:edit] do
  	resources :inventories, only: [:create]
  	post :flag_infected, on: :member
  	post :trade, on: :member
  end
    
end
