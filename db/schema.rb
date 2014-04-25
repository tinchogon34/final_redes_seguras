# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140424172909) do

  create_table "coord_card_items", force: true do |t|
    t.integer  "coord_card_id"
    t.text     "coord"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coord_card_items", ["coord_card_id"], name: "index_coord_card_items_on_coord_card_id"

  create_table "coord_cards", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coord_cards", ["user_id"], name: "index_coord_cards_on_user_id"

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.text     "encrypted_password"
    t.datetime "last_login_at"
    t.text     "confirm_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
