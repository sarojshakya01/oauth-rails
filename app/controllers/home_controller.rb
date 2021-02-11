# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    if !current_user.cc_admin
      current_app_id = current_user.access_tokens.last.application_id
      app_url = OauthApplication.find(current_app_id).url if current_app_id > 0
      redirect_to (app_url || '/404')
    end
  end
end
