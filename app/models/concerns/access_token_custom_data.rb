module AccessTokenCustomData
  extend ActiveSupport::Concern

  included do
    before_create :set_resource_session_id

    private
    def set_resource_session_id
      self.resource_session_id = User.find(self.resource_owner_id).last_session_id
    end
  end
end