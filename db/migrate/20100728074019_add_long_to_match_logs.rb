class AddLongToMatchLogs < ActiveRecord::Migration
  def self.up
    add_column :match_logs, :long, :double
  end

  def self.down
    remove_column :match_logs, :long
  end
end
