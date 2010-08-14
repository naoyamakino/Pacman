class CreateAchievements < ActiveRecord::Migration
  def self.up
    create_table :achievements do |t|
      t.belongs_to :user
      t.string :name, :desc
      t.timestamps
    end
  end

  def self.down
    drop_table :achievements
  end
end
