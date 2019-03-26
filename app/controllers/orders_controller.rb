class OrdersController < ApplicationController

   def new
     @cart = cart

     @order = Order.new
   end

   def create
     @order = Order.create(order_params)

     redirect_to @order
   end

  def show
    @order = Order.find(params[:id])
  end



  private

  def order_params
    params.require(:order).permit(:street, :city, :state, :zip)
  end
end
