class Address < ApplicationRecord

  belongs_to :customer

  validates :customer_id, :name, :address, presence: true
  
  
  def address_display
  '〒' + postal_code + ' ' + address + ' ' + name
  end
end
