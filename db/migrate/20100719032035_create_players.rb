class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.belongs_to :user
      t.belongs_to :game
      t.double :latitude, :longitude
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
