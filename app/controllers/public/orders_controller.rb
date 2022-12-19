class Public::OrdersController < ApplicationController
  # before_action :authenticate_customer!
  
  # 注文情報入力
  def new
    @order = Order.new
    # @addresses = current_customer.addresses.all
  end
  
  # 注文情報確認
  def confirm
    @cart_items = current_customer.cart_items.all
    @order = Order.new(order_params)
    @order.payment_method = params[:order][:payment_method]
    @order.shipping_cost = 800
    # 会員の住所の表示
    if params[:order][:select_address] == "0"
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + current_customer.first_name
      render :confirm
    elsif params[:order][:select_address] == "1"
      @address = Address.find(params[:order][:address_id])
      @order.postal_code = @address.postal_code
      @order.address = @address.address
      @order.name = @address.name
    elsif params[:order][:select_address] == "2"
      @order.postal_code = @order.postal_code
      @order.address = @order.address
      @order.name = @order.name
    else
      render :new
    end
  end
  
  # 注文履歴一覧
  def index
    # (create_at: :desc)で降順(大から表示）、(create_at: :asc)で昇順（小から表示）
    @orders = current_customer.orders.order(create_at: :desc)
  end
  # 注文履歴詳細
  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details
    @order.shipping_cost = 800
  end
  # 注文完了
  def complete
  end
  # 注文確定処理
  def create
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    if @order.save
      @cart_items = current_customer.cart_items
      ###カート破棄前に注文詳細へ保存する記述###
      @cart_items.each do |cart_item| 
        order_detail = OrderDetail.new(order_id: @order.id)
        order_detail.item_id = cart_item.item_id
        order_detail.price = cart_item.item.price * 1.1
        order_detail.amount = cart_item.amount
        order_detail.making_status = 0
        order_detail.save
      end
      ##########ここまで##########
      @cart_items.destroy_all
      redirect_to orders_complete_path
    else
      render :new
    end
  end
  
  private
  def order_params
    params.require(:order).permit(:shipping_cost, :payment_method, :name, :address, :postal_code ,:customer_id, :total_payment, :status)
  end
  
  def address_params
    params.require(:order).permit(:postal_code, :address, :name)
  end
end