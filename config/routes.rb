Rails.application.routes.draw do
  use_doorkeeper do
    controllers applications: 'oauth_applications'
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  namespace :api do
    namespace :v1 do
      get '/resource' => 'credentials#user'
    end
  end

  root to: 'home#index'
end