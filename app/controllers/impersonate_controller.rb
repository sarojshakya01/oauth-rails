class ImpersonateController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def impersonate
    @oauth_impersonate = OauthImpersonate.new
    @oauth_impersonate.super_user_id = 101
    @oauth_impersonate.user_id = 1
    @oauth_impersonate.valid_till = Time.now + 1000
    @oauth_impersonate.token = SecureRandom.hex(64)

    if @oauth_impersonate.save
      render json: {:token => @oauth_impersonate.token}
    else
      render json: {:token => nil}
    end
  end
end