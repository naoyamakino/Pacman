class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.has_many :pac_dots
      t.string :name, :password, :status, :area
      t.boolean :hasPowerups, :isPrivate
      t.has_many :players
      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
