class Users::UsersController < ApplicationController
  def impersonate
    @impersonate = validate_impersonate_token params[:token]
    if params[:app_name] == 'ccan'
      app_url = Rails.application.config.ccan_app_url
    end

    if @impersonate
      if user_signed_in?
        sign_out current_user
      end
      @impersonate.update_attribute(:token,nil)

      #skip devise trackable fields on impersonating
      # env["devise.skip_trackable"] = true

      sign_in(:user, User.find_by(app_user_id: @impersonate.user_id))

      # Hide Session Expiry, if previous session is expired
      session[:is_impersonated] = true

      redirect_to app_url
    else
      redirect_to app_url + '/404'
    end
  end

  def validate_impersonate_token token
    if token.length == 128
      @impersonate = OauthImpersonate.find_by(:token=> token) || not_found
      return false if !User.where(app_user_id: @impersonate.user_id).exists?
      if !@impersonate.valid_till.past?
        return @impersonate
      end
    end
    return false
  end
end