class AddColumnsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :current_sign_in_ip, :text
    add_column :users, :last_sign_in_ip, :text
    add_column :users, :sign_in_count, :int
  end
end
