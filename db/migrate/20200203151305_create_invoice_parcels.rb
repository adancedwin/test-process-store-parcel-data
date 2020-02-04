class CreateInvoiceParcels < ActiveRecord::Migration[6.0]
  def change
    create_table :invoice_parcels do |t|
      t.integer :invoice_id, null: false
      t.string :parcel_code
      t.index :parcel_code, unique: true
      t.integer :quantity
      t.decimal :price, precision: 7, scale: 2

      t.timestamps
    end
  end
end
