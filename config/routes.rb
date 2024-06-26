Rails.application.routes.draw do
  resources :users, only: [:show, :destroy, :index]
  get 'users/:id/goals', to: 'users#generate_goals'
  put 'users/:id/appliances', to: "users#appliances"
  post 'signup', to: 'users#create'
  post 'login', to: 'users#login'
end
