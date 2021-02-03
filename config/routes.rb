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

  unauthenticated :user do
    devise_scope :user do
      root to: 'users/sessions#new'
    end

    devise_scope :user do
      get '/(:account_name)', to: 'users/sessions#new'
    end
  end

  namespace :api do
    namespace :v1 do
      get '/logout' => 'credentials#logout'
      get '/resource' => 'credentials#user'
    end
  end

  authenticated :user do
    root to: 'home#index', as: 'home'

    devise_scope :user do
      get '/(:account_name)', to: 'home#index'
    end
  end

end