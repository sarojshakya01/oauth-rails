# frozen_string_literal: true

module Api::V1
  class CredentialsController < ApiController
    before_action -> { doorkeeper_authorize! :resouce }, only: :me
    
    def me
      render json: 1
    end
  end
end
