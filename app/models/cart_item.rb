class CartItem < ApplicationRecord
  belongs_to :customer
  belongs_to :item
  
  # 税込価格✕個数
  def sum_price
    item.taxin_price*quantity
  end
end
