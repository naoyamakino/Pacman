class AddUsersColumns < ActiveRecord::Migration
  def self.up
  end
	add_column :users, :username, :string
	add_column :users, :email, :string
	add_column :users, :crypted_password, :string
	add_column :users, :password_salt, :string
	add_column :users, :persistence_token, :string
  def self.down
  end
end
