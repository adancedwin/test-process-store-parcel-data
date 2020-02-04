# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_03_151305) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "batches", force: :cascade do |t|
    t.string "sales_batch_id", null: false
    t.string "file_guid", null: false
    t.date "creation_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["file_guid"], name: "index_batches_on_file_guid", unique: true
    t.index ["sales_batch_id"], name: "index_batches_on_sales_batch_id", unique: true
  end

  create_table "invoice_parcels", force: :cascade do |t|
    t.integer "invoice_id", null: false
    t.string "parcel_code"
    t.integer "quantity"
    t.decimal "price", precision: 7, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["parcel_code"], name: "index_invoice_parcels_on_parcel_code", unique: true
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "operation_number"
    t.date "operation_date"
    t.integer "company_id"
    t.integer "batch_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["operation_number"], name: "index_invoices_on_operation_number"
  end

end
