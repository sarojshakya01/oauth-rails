class OauthImpersonate < ApplicationRecord
  self.table_name = 'oauth_impersonates'
  belongs_to :user
end