class CreateBatches < ActiveRecord::Migration[6.0]
  def change
    create_table :batches do |t|
      t.string :sales_batch_id, null: false
      t.index :sales_batch_id, unique: true
      t.string :file_guid, null: false
      t.index :file_guid, unique: true
      t.date :creation_date

      t.timestamps
    end
  end
end
