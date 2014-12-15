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

ActiveRecord::Schema.define(version: 20141116201833) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fb_accounts", force: true do |t|
    t.string   "ad_account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "funnels", force: true do |t|
    t.string   "name"
    t.string   "goal"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "steps", force: true do |t|
    t.string   "url"
    t.string   "title"
    t.text     "description"
    t.text     "meta"
    t.text     "internal_links"
    t.text     "external_links"
    t.integer  "funnel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "session_token"
    t.string   "uid"
    t.string   "access_token"
    t.string   "expires"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "refresh_token"
    t.string   "fb_access_token"
    t.text     "serialized_ga_views"
  end

end
