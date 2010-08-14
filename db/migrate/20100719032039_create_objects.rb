class CreateObjects < ActiveRecord::Migration
  def self.up
    create_table :objects do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :objects
  end
end
