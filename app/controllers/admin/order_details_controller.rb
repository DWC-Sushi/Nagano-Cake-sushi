class Admin::OrderDetailsController < ApplicationController
  
before_action :authenticate_admin!
  
  def update
    @order = Order.Find(params[:id])
    @customer = @order.customer
    @order_details = Order_detail.all
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: "You have updated order successfully."
    else
      render :edit_admin_customer_path
    end
  end
end
