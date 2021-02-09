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
    get   'myprofile/pass'  => 'devise/registrations#edit',      :as => 'edit_user_registration'
    patch 'myprofile/pass' => 'devise/registrations#update',    :as => 'user_registration'
    get   'myprofile',            to: 'users#profile',    as: 'user_profile'
    patch 'myprofile/(:id)',      to: 'users#update',     as: 'user'
    get   'myprofile/edit/(:id)', to: 'users#edit',       as: 'edit_profile'
    get   'users/send_invitation/(:id)',      to: 'users#send_invitation', as: 'send_invitation'
    get   'users', to: 'users#index', as: 'users'
    get   'users/mirror_new/:id', to: 'users/invitations#mirror_new', as: 'new_mirror_user_invitation'
    delete 'myprofile/(:id)', to: 'users#destroy', as: 'user_destroy'
    get '/logout', to: 'users/sessions#logout'
  end

  unauthenticated :user do
    post 'register', to: 'dashboard#marketplace_registration'

    devise_scope :user do
      root to: 'doorkeeper/authorizations#new'
    end

    devise_scope :user do
      get '/(:account_name)', to: 'users/sessions#new'
    end
  end
  
  namespace :api do
    namespace :v1 do
      get '/logout' => 'logout#logout'
      get '/resource' => 'credentials#user'
    end
  end

  authenticated :user do
    root to: 'home#index', as: 'home'

    devise_scope :user do
      get '/(:account_name)', to: 'home#index'
    end
  end

  #route for impersonate
  get 'users/impersonate/:token', to: 'users/users#impersonate'
  post '/impersonate_token', to: 'impersonate#impersonate'
end