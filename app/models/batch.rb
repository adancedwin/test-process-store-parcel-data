class Batch < ApplicationRecord
  has_many :invoices, dependent: :delete_all

  accepts_nested_attributes_for :invoices, allow_destroy: true

  validates :file_guid, :sales_batch_id, presence: true, uniqueness: true
end