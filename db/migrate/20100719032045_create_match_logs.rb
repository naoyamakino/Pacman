class CreateMatchLogs < ActiveRecord::Migration
  def self.up
    create_table :match_logs do |t|
      t.belongs_to :game
      t.belongs_to :player
      t.double :latitude, :longitude
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :match_logs
  end
end
