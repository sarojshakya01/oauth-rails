class CreateOauthImpersonates < ActiveRecord::Migration[6.1]
  def change
    create_table :oauth_impersonates do |t|
      t.integer :super_user_id
      t.integer :user_id
      t.string :token
      t.timestamp :valid_till

      t.timestamps
    end
  end
end
