class AddColumnsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string
    add_column :users, :status, :string
    add_column :users, :account_name, :string
    add_column :users, :password_changed_at, :datetime
  end
end
