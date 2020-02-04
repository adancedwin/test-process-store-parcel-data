class Invoice < ApplicationRecord
  has_many :parcels, class_name: 'Invoice::Parcel', dependent: :delete_all
  belongs_to :batch

  accepts_nested_attributes_for :parcels, allow_destroy: true
end