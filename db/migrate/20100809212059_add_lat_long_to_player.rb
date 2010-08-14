class AddLatLongToPlayer < ActiveRecord::Migration
  def self.up
    # Add duplicate columns to Player. 
    add_column :players, :lat, :double
    add_column :players, :long, :double
  end

  def self.down
    remove_column :players, :lat
    remove_column :players, :long
  end
end
