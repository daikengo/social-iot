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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130410155430) do

  create_table "api_keys", :force => true do |t|
    t.string   "api_key",    :limit => 16
    t.integer  "channel_id"
    t.integer  "user_id"
    t.boolean  "write_flag",               :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "note"
  end

  add_index "api_keys", ["api_key"], :name => "index_api_keys_on_api_key", :unique => true
  add_index "api_keys", ["channel_id"], :name => "index_api_keys_on_channel_id"

  create_table "channels", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "description"
    t.string   "field1"
    t.string   "field2"
    t.string   "field3"
    t.string   "field4"
    t.string   "field5"
    t.string   "field6"
    t.string   "field7"
    t.string   "field8"
    t.string   "field9"
    t.string   "field10"
    t.string   "field11"
    t.string   "field12"
    t.string   "field13"
    t.string   "field14"
    t.string   "field15"
    t.string   "field16"
    t.integer  "scale1"
    t.integer  "scale2"
    t.integer  "scale3"
    t.integer  "scale4"
    t.integer  "scale5"
    t.integer  "scale6"
    t.integer  "scale7"
    t.integer  "scale8"
    t.integer  "scale9"
    t.integer  "scale10"
    t.integer  "scale11"
    t.integer  "scale12"
    t.integer  "scale13"
    t.integer  "scale14"
    t.integer  "scale15"
    t.integer  "scale16"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "last_entry_id"
    t.boolean  "public_flag",                   :default => true
    t.string   "options1"
    t.string   "options2"
    t.string   "options3"
    t.string   "options4"
    t.string   "options5"
    t.string   "options6"
    t.string   "options7"
    t.string   "options8"
    t.string   "options9"
    t.string   "options10"
    t.string   "options11"
    t.string   "options12"
    t.string   "options13"
    t.string   "options14"
    t.string   "options15"
    t.string   "options16"
    t.string   "model",           :limit => 20
    t.string   "brand",           :limit => 20
    t.string   "device_type",     :limit => 20
    t.boolean  "mobility_status"
    t.integer  "location"
    t.string   "location_name",   :limit => 20
    t.integer  "location_type"
    t.integer  "aut_ind_loc",     :limit => 1,  :default => 1,    :null => false
    t.boolean  "oor_flag",                      :default => true
    t.boolean  "por_flag",                      :default => true
    t.boolean  "cwor_flag",                     :default => true
    t.boolean  "sor_flag",                      :default => true
    t.boolean  "clor_flag",                     :default => true
    t.string   "bt_mac_address",  :limit => 17
    t.string   "wf_mac_address",  :limit => 17
  end

  create_table "feeds", :force => true do |t|
    t.integer  "channel_id"
    t.text     "raw_data"
    t.string   "field1"
    t.string   "field2"
    t.string   "field3"
    t.string   "field4"
    t.string   "field5"
    t.string   "field6"
    t.string   "field7"
    t.string   "field8"
    t.string   "field9"
    t.string   "field10"
    t.string   "field11"
    t.string   "field12"
    t.string   "field13"
    t.string   "field14"
    t.string   "field15"
    t.string   "field16"
    t.float    "gps_precision"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "entry_id"
    t.string   "status"
    t.string   "elevation"
  end

  add_index "feeds", ["channel_id", "created_at"], :name => "index_feeds_on_channel_id_and_created_at"
  add_index "feeds", ["channel_id", "entry_id"], :name => "index_feeds_on_channel_id_and_entry_id"

  create_table "group_relations", :force => true do |t|
    t.integer  "channel_id"
    t.integer  "ttl"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groups", :force => true do |t|
    t.integer  "place_id"
    t.string   "tag1"
    t.string   "tag2"
    t.string   "tag3"
    t.integer  "ttl"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "places", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.integer  "creator_id"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "range"
    t.integer  "floor"
    t.boolean  "public"
    t.boolean  "home"
    t.boolean  "work"
    t.integer  "superplace"
    t.boolean  "gmaps",      :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "relationships", :force => true do |t|
    t.integer  "guid_one"
    t.string   "relation"
    t.integer  "guid_two"
    t.datetime "time_created"
    t.datetime "updated_at"
  end

  create_table "user_admins", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "user_admins", ["email"], :name => "index_user_admins_on_email", :unique => true
  add_index "user_admins", ["reset_password_token"], :name => "index_user_admins_on_reset_password_token", :unique => true

  create_table "users", :force => true do |t|
    t.string   "login",                                          :null => false
    t.string   "email",                                          :null => false
    t.string   "crypted_password",                               :null => false
    t.string   "password_salt",                                  :null => false
    t.string   "persistence_token",                              :null => false
    t.string   "perishable_token",                               :null => false
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone"
    t.string   "home_location",     :limit => 20
    t.string   "work_place",        :limit => 20
    t.integer  "admin",             :limit => 1,  :default => 0, :null => false
  end

end
