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

ActiveRecord::Schema[7.1].define(version: 2024_06_27_192531) do
  create_table "bands", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enemies", force: :cascade do |t|
    t.string "language", default: "en"
    t.integer "band_id", null: false
    t.string "title", null: false
    t.text "body", default: ""
    t.text "comment", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["band_id"], name: "index_enemies_on_band_id"
  end

  create_table "fights", force: :cascade do |t|
    t.integer "ring_id", null: false
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ring_id"], name: "index_fights_on_ring_id"
  end

  create_table "punches", force: :cascade do |t|
    t.integer "enemy_id", null: false
    t.integer "fight_id", null: false
    t.string "puppet_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enemy_id"], name: "index_punches_on_enemy_id"
    t.index ["fight_id", "enemy_id", "puppet_name"], name: "index_punches_on_fight_id_and_enemy_id_and_puppet_name", unique: true
  end

  create_table "puppets", primary_key: ["enemy_id", "name"], force: :cascade do |t|
    t.integer "enemy_id", null: false
    t.string "name", null: false
    t.text "body", null: false
    t.boolean "correct", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enemy_id"], name: "index_puppets_on_enemy_id"
  end

  create_table "rings", force: :cascade do |t|
    t.integer "band_id", null: false
    t.integer "maximum_score", null: false
    t.integer "treshold", default: 75
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["band_id"], name: "index_rings_on_band_id"
  end

  create_table "rounds", primary_key: ["fight_id", "enemy_id"], force: :cascade do |t|
    t.integer "fight_id", null: false
    t.integer "enemy_id", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enemy_id"], name: "index_rounds_on_enemy_id"
    t.index ["fight_id"], name: "index_rounds_on_fight_id"
  end

  add_foreign_key "enemies", "bands", on_delete: :cascade
  add_foreign_key "fights", "rings", on_delete: :restrict
  add_foreign_key "punches", "enemies", on_delete: :restrict
  add_foreign_key "punches", "puppets", column: ["enemy_id", "puppet_name"], primary_key: ["enemy_id", "name"], on_delete: :restrict
  add_foreign_key "punches", "rounds", column: ["fight_id", "enemy_id"], primary_key: ["fight_id", "enemy_id"], on_delete: :cascade
  add_foreign_key "puppets", "enemies", on_delete: :cascade
  add_foreign_key "rings", "bands", on_delete: :cascade
  add_foreign_key "rounds", "enemies", on_delete: :restrict
  add_foreign_key "rounds", "fights", on_delete: :cascade
end
