class CreateStats < ActiveRecord::Migration
  def self.up
    create_table :stats do |t|
      t.belongs_to :user
      t.integer :games_won_as_ghost, :games_won_as_pacman, :total_ghosts_eaten, :total_pacman_eaten
      t.float :total_distance
      t.timestamps
    end
  end

  def self.down
    drop_table :stats
  end
end
