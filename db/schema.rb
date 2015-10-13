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

ActiveRecord::Schema.define(version: 20150828093535) do

  create_table "nodes", force: true do |t|
    t.string   "name",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "certified",      default: false, null: false
    t.string   "virtual"
    t.string   "osarch"
    t.string   "osfamily"
    t.string   "osname"
    t.string   "oscodename"
    t.string   "osversion"
    t.string   "kernel"
    t.string   "role"
    t.string   "profile"
    t.string   "environment"
    t.string   "description"
    t.string   "memorysize"
    t.string   "processorcount"
  end

  create_table "optgroups", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "optgroups_systemroles", force: true do |t|
    t.integer "optgroup_id",   null: false
    t.integer "systemrole_id", null: false
  end

  add_index "optgroups_systemroles", ["optgroup_id", "systemrole_id"], name: "index_optgroups_systemroles_on_optgroup_id_and_systemrole_id", unique: true

  create_table "puppet_modules", force: true do |t|
    t.string   "name"
    t.string   "version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "environment"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "shells", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "systemroles", force: true do |t|
    t.string   "name",       null: false
    t.integer  "gid",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "systemusers", force: true do |t|
    t.string   "name",          null: false
    t.integer  "uid",           null: false
    t.string   "ensure",        null: false
    t.text     "comment",       null: false
    t.boolean  "manage_home"
    t.string   "password"
    t.string   "sshkey"
    t.string   "sshkeytype"
    t.integer  "shell_id",      null: false
    t.integer  "systemrole_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "keyfile"
  end

  create_table "users", force: true do |t|
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token"
  end

end
