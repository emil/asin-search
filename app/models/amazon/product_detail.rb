class Amazon::ProductDetail < ApplicationRecord
  belongs_to :product
  
  validates_presence_of :label, :value
end
