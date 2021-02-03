# frozen_string_literal: true

module Api::V1
  class ApiController < ::ApplicationController
    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    def logout_current_resource_owner
      User.find(doorkeeper_token.resource_owner_id).access_grants.delete_all
      User.find(doorkeeper_token.resource_owner_id).access_tokens.delete_all
      ActiveRecord::SessionStore::Session.find_by_session_id(User.find(doorkeeper_token.resource_owner_id).session_id).delete
      {:status => 'ok'}
    end
  end
end
