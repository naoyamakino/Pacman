class AddNumPlayersToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :NumPlayers, :int
  end

  def self.down
    remove_column :games, :NumPlayers
  end
end
