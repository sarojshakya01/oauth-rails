class ApplicationController < ActionController::Base
  layout :layout_by_resource

  private
  def layout_by_resource
    # Plain layout for Login / Forgot Password
    if !user_signed_in?
      'simplelayout'
    else
      'application'
    end
  end
end
