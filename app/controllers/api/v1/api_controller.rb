# frozen_string_literal: true

module Api::V1
  class ApiController < ::ApplicationController
    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    def logout_current_resource_owner
      session = ActiveRecord::SessionStore::Session
      this_session = doorkeeper_token.resource_session_id
      session.find_by_session_id(this_session).delete if !session.find_by_session_id(this_session).nil
      doorkeeper_token.delete
      {:status => 'ok'}
    end
  end
end
