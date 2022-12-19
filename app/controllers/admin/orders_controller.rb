class Admin::OrdersController < ApplicationController
  def show
    @order_details = OrderDetail.where(order_id: params[:id])
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    @order_details = @order.order_details
     if @order.update(order_params)
        @order.order_details.update_all(status: 1)
       redirect_to request.referer
     else
       redirect_to request.referer
     end
  end


    @order = Order.find(params[:id])
    @order.update(order_params)
    redirect_to request.referer
  end
  
  private

  def order_params
    params.require(:order).permit(:status)
  end
  
end
