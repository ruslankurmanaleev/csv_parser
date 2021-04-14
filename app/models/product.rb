class Product < ApplicationRecord
  validates :price_list, :brand, :code, :stock, :cost, presence: true

  validates_numericality_of :cost, precision: 12, scale: 2
end
