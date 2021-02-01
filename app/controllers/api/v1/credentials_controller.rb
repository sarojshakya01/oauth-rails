# frozen_string_literal: true

module Api::V1
  class CredentialsController < ApiController
    # before_action -> { doorkeeper_authorize! :resouce }, only: :me
    before_action :doorkeeper_authorize!
    
    def user
      render json: current_resource_owner
    end
  end
end
