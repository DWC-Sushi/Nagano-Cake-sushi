class Public::AddressesController < ApplicationController


  def index
    @addresses = current_customer.addresses
    @address = Address.new
  end

  def edit
    @address= Address.find(params[:id])

  end

  def create
    @address = Address.new(address_params)
    @address.customer_id= current_customer.id
    @addresses = current_customer.addresses
    if @address.save
      redirect_to addresses_path(@address),
      flash.now[:notice] = "新規配送先を登録しました"
    else
      render :index
    end
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      redirect_to address_path
      flash.now[:notice] = '配送先を変更しました'
    else
      render :edit
    end
  end

  def destroy
    @address = Address.find(params[:id])
    @address.delete(address_params)
      redirect_to address_path
      flash.now[:notice] = '配送先を削除しました'
  end

  private

  def address_params
    params.require(:address).permit(:postal_code, :address, :name)
  end
end