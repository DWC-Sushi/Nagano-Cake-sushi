class Public::CartItemsController < ApplicationController

  # カートの中の一覧
  def index
    @cart_items = current_customer.cart_items.all
    @total_price = @cart_items.sum{|cart_item|cart_item.item.price_without_tax * cart_item.amonut * 1.1}
  end

  # カートの中にに商品を追加
  def create
    @cart_item = CartItem.new(cart_item_params)
    @cart_item.customer_id = current_customer.id
    @cart_item.item_id = params[:item_id]

    if @cart_item.save
      flash[:notice] = "#{@cart_item.item.name}をカートに追加しました。"
      redirect_to customers_cart_items_path
    else
      flash[:alert] = "個数を選択してください"
      render "customers/items/show"
    end
  end

  # 削除,個数の変更時、カート商品を再計算する
  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(cart_item_params)
    redirect_to customers_cart_items_path
  end

  # カートの中の商品を一つだけ削除する
  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    flash.now[:alert] = "#{@cart_item.item.name}を削除しました"
    redirect_to customers_cart_items_path
  end

  # カートの中を全て削除する
  def destroy_all
    @cart_item = current_customer.cart_items
    @cart_item.destroy_all
    flash[:alert] = "カートの商品を全て削除しました"
    redirect_to customers_cart_items_path
  end

  private
 def item_params
  params.require(:cart_items).permit(:item_id,:customer_id,:amount,:image_id,:price)
 end
end
