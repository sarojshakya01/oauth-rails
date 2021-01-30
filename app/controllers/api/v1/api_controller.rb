# frozen_string_literal: true

module Api::V1
  class ApiController < ::ApplicationController
    def current_resource_owner
      puts "******************************************"
      puts doorkeeper_token
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
  end
end
