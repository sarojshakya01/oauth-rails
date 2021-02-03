# frozen_string_literal: true

module Api::V1
  class CredentialsController < ApiController
    before_action :doorkeeper_authorize!
    respond_to    :json
    
    def user
      render json: current_resource_owner
    end

    def logout
      render json: logout_current_resource_owner
    end
  end
end
