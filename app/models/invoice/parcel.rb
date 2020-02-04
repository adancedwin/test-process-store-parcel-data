class Invoice::Parcel < ApplicationRecord
  belongs_to :invoice

  validates :parcel_code, presence: true, uniqueness: true
end