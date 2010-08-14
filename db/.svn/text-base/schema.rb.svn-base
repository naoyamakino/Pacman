# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100811174252) do

  create_table "achievements", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "avatars", :force => true do |t|
    t.integer "user_id"
    t.integer "parent_id"
    t.string  "content_type"
    t.string  "filename"
    t.string  "thumbnail"
    t.integer "size"
    t.integer "width"
    t.integer "height"
  end

  create_table "games", :force => true do |t|
    t.string   "name"
    t.string   "password"
    t.string   "status"
    t.string   "area"
    t.boolean  "hasPowerups"
    t.boolean  "isPrivate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude2"
    t.float    "longitude2"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "NumPlayers"
    t.integer  "MaxPlayers"
    t.string   "salt"
  end

  create_table "match_logs", :force => true do |t|
    t.integer  "game_id"
    t.integer  "player_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "long"
  end

  create_table "objects", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "type"
    t.boolean  "isVisible"
  end

  create_table "pac_dots", :force => true do |t|
    t.integer  "game_id"
    t.boolean  "is_eaten"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "isPowerup"
  end

  create_table "players", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "playerType"
    t.integer  "ghosts_eaten"
    t.float    "lat"
    t.float    "long"
    t.datetime "expiry"
  end

  create_table "stats", :force => true do |t|
    t.integer  "user_id"
    t.integer  "games_won_as_ghost"
    t.integer  "games_won_as_pacman"
    t.integer  "total_ghosts_eaten"
    t.integer  "total_pacman_eaten"
    t.float    "total_distance"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "points"
  end

  create_table "users", :force => true do |t|
    t.string   "country"
    t.string   "province"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "perishable_token",  :default => "", :null => false
  end

end
