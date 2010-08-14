class AddSecondLatlongToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :latitude2, :double
    add_column :games, :longitude2, :double
    add_column :games, :latitude, :double
    add_column :games, :longitude, :double
  end

  def self.down
    remove_column :games, :longitude2
    remove_column :games, :latitude2
    remove_column :games, :latitude
    remove_column :games, :longitude
  end
end
