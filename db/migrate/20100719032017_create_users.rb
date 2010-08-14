class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.has_one :avatar
      t.has_one :stat
      t.string :country, :province      
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
