class Public::ItemsController < ApplicationController

  def index
     @items = Item.where(is_active: true).page(params[:page]).per(8)
  end

  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
  end

  def item_params
   params.require(:item).permit(:image, :name, :introduction, :price, :genre_id , :is_active)
  end
end
