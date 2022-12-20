class Public::ItemsController < ApplicationController

  def index
     @items = Item.where(is_active: true).page(params[:page]).per(8)
     @genres = Genre.all
     if params[:genre_id].present?
       @genre = Genre.find(params[:genre_id])
       @items = @genre.items.where(is_active: true).page(params[:page]).per(8)
     end
  end

  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
    @genres = Genre.all
     if params[:genre_id].present?
       @genre = Genre.find(params[:genre_id])
       @items = @genre.items.where(is_active: true).page(params[:page]).per(8)
    end
  end

  def item_params
   params.require(:item).permit(:image, :name, :introduction, :price, :genre_id , :is_active)
  end
end
