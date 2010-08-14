class AddPlayerTypeToPlayers < ActiveRecord::Migration
  def self.up
    add_column :players, :playerType, :string
  end

  def self.down
    remove_column :players, :playerType
  end
end
