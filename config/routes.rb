Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :planets do
    member do
      get :resources, to: 'planets#resources'
      get :object, to: 'planets#show_object'
      post :object, to: 'planets#build_object'
    end
  end
  
end
