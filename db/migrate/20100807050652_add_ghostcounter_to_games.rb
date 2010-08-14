class AddGhostcounterToGames < ActiveRecord::Migration
  def self.up
    add_column :players, :ghosts_eaten, :integer
  end

  def self.down
  end
end
