Rails.application.routes.draw do
  use_doorkeeper do
    controllers applications: 'oauth_applications'
  end

  devise_for :users, skip: [:registration, :authentication], controllers: {
    :invitations => 'users/invitations',
    :sessions=>'users/sessions',
    :passwords=>'users/passwords',
    :unlocks=>'users/unlocks',
  } do    
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  devise_scope :user do
    get '/logout', to: 'users/sessions#logout'
    get '/oauth_users/invitation/accept', to: 'users/invitations#edit'
    get '/pass'  => 'devise/registrations#edit', :as => 'edit_user_registration'
    patch '/pass' => 'devise/registrations#update', :as => 'user_registration'
    get '/admin/users/sign_in', to: 'users/sessions#new'
  end

  namespace :api do
    namespace :v1 do
      get '/resource' => 'credentials#user'
    end
  end

  authenticated :user do
    root to: 'home#index', as: 'home'
  end

  #route for impersonate
  get 'users/impersonate', to: 'users/users#impersonate'
  post '/impersonate_token', to: 'impersonate#impersonate'
end