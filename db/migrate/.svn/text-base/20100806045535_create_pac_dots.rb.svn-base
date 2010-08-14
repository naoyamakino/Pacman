class CreatePacDots < ActiveRecord::Migration
  def self.up
    create_table :pac_dots do |t|
      t.belongs_to :game
      t.double :latitude
      t.double :longitude
      t.boolean :is_eaten

      t.timestamps
    end
  end

  def self.down
    drop_table :pac_dots
  end
end
