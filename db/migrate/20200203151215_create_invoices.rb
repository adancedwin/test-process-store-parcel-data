class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.integer :operation_number
      t.index :operation_number
      t.date :operation_date
      t.integer :company_id
      t.integer :batch_id, null: false

      t.timestamps
    end
  end
end
