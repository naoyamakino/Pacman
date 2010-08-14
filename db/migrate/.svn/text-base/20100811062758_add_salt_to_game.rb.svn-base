class AddSaltToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :salt, :string
  end

  def self.down
    drop_column :games, :salt
  end
end
