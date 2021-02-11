# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params

  # GET /resource/sign_in
  def new
    super
    session[:is_multiple_account] = false
    if (!sign_in_params.nil?) && (!sign_in_params.empty?)
      # abort sign_in_params.inspect
      user_id = 0
      user = User.find_by(:email => sign_in_params[:email], :account_name => sign_in_params[:account_name])
      if user
        user_id = user.id
      end

      temp_sign_in_params = {
          :id => user_id,
          :password => sign_in_params[:password],
          :remember_me => 0
      }

      self.resource = resource_class.new(temp_sign_in_params)

      self.resource.email = sign_in_params[:email]
      clean_up_passwords(resource)
      yield resource if block_given?
    end
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  def destroy
    if current_user
      current_user.access_grants.delete_all
      current_user.access_tokens.delete_all
    end
    super
  end

  def logout
    
    if current_user
      current_user.access_grants.delete_all
      current_user.access_tokens.delete_all
    end
    sign_out

    # check the name of app
    if params[:app_name] == 'ccan'
      redirect_to Rails.application.config.ccan_app_url
    end
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:account_name])
  end
end
