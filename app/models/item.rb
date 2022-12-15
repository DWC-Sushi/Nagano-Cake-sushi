class Item < ApplicationRecord
  belongs_to :genre
  has_many :order_details, dependent: :destroy
  has_many :carts, dependent: :destroy
  has_many :orders, through: :order_details

  has_many :cart_items
  has_many :order_details

  has_one_attached :image

  validates :introduction, presence: true
  validates :name, presence: true
  validates :price, presence: true, numericality: { only_integer: true }
  validates :is_active, inclusion: {in: [true, false]}
  
  # 消費税
  def taxin_price
    price*1.08
  end
end
