class AddColumnsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string
    add_column :users, :status, :boolean
    add_column :users, :account_name, :string
    add_column :users, :password_changed_at, :datetime
    add_column :users, :app_user_id, :integer
  end
  add_index :users, :app_user_id, name: 'index_app_user_id'
end
