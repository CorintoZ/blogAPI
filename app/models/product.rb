class Product < ApplicationRecord
  # Validations
  validates_presence_of :name, :description, :price, :stock
  validates_numericality_of :price, :greater_than_or_equal_to => 0
  validates_numericality_of :stock, :greater_than_or_equal_to => 0
end
