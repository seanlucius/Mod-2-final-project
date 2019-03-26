class OrdersController < ApplicationController

   def new
     @cart = cart

     @order = Order.new
   end

   def create
     @order = Order.create(order_params)

     redirect_to add_path
   end

   def index
     @cart = cart
   end

  def show

  end



  private

  def order_params
    params.require(:order).permit(:street, :city, :state, :zip)
  end
end
