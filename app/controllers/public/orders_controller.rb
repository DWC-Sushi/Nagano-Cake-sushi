class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!
  
  
  def new # 注文情報入力画面
    @order = Order.new
    @addresses = current_customer.addresses.all
  end
  
  def confirm   # 注文情報入力確認画面
    @order = Order.new(order_params)

    #  [:address_option]=="0"のデータ(memberの住所)を呼び出す
    if params[:order][:address_option] == "0"
    @order.post_code = current_customer.post_code
    @order.address = current_customer.address
    @order.name = current_customer.last_name + current_customer.first_name 
    # [:address_option]=="1"を呼び出す
    elsif params[:order][:address_option] == "1"
    ship = Address.find(params[:order][:customer_id])
　　#orderのmember_id(=カラム)でアドレス(帳)を選び、そのデータ送る
    @order.post_code = ship.post_code
    @order.address = ship.address
    @order.name = ship.name 
      
    # 新規住所入力 [:address_option]=="2"としてデータをhtmlから受ける
    elsif params[:order][:address_option] = "2"
    @order.post_code = params[:order][:post_code]
    @order.address = params[:order][:address]
    @order.name = params[:order][:name]
    else
      render 'new'
    end
    
    @cart_items = current_customer.cart_items.all
    @order.customer_id = current_custmer.id
  end

  def index
    @orders = current_custmer.orders
  end

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details
  end

  def complete
  end

  def create
    @order = Order.new(order_params)
    @order.customer_id = current_custmer.id
    @order.save
    
    # ordered_itmemの保存
    current_customer.cart_items.each do |cart_item| #カートの商品を1つずつ取り出しループ
      @order_details = OrderDetail.new #初期化宣言
      @order_details.item_id = cart_item.item_id #商品idを注文商品idに代入
      @order_details.amonut = cart_item.amount #商品の個数を注文商品の個数に代入
      @order_details.tax_included_price = (cart_item.item.price*1.08).floor #消費税込みに計算して代入
      @order_details.order_id =  @order.id #注文商品に注文idを紐付け
      @order_details.save #注文商品を保存
    end #ループ終わり

    current_customer.cart_items.destroy_all #カートの中身を削除
    redirect_to complete_orders_path
  end
  
  private
  def order_params
    params.require(:order).permit(:postage, :payment_method, :name, :address, :post_code ,:customer_id, :total_payment, :status)
  end
end