# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_05_09_000000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "menus", force: :cascade do |t|
    t.string "name", null: false
    t.integer "target_temp", default: 75, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_menus_on_name", unique: true
  end

  create_table "temperature_records", force: :cascade do |t|
    t.bigint "menu_id", null: false
    t.bigint "user_id", null: false
    t.integer "temperature", null: false
    t.datetime "measured_at", null: false
    t.integer "set_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["measured_at"], name: "index_temperature_records_on_measured_at"
    t.index ["menu_id", "measured_at", "set_id"], name: "idx_on_menu_id_measured_at_set_id_5ecae4b503"
    t.index ["menu_id", "measured_at"], name: "index_temperature_records_on_menu_id_and_measured_at"
    t.index ["menu_id", "set_id"], name: "index_temperature_records_on_menu_id_and_set_id"
    t.index ["menu_id"], name: "index_temperature_records_on_menu_id"
    t.index ["set_id"], name: "index_temperature_records_on_set_id"
    t.index ["user_id"], name: "index_temperature_records_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "crypted_password", null: false
    t.string "salt", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  add_foreign_key "temperature_records", "menus"
  add_foreign_key "temperature_records", "users"
end
