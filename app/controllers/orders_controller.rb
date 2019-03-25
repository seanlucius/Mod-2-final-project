class OrdersController < ApplicationController

   def new
     @cart = cart

     @order = Order.new
   end

   def create
     @order = Order.create(order_params)

     redirect_to :index
   end

  def show
    @cart = cart
  end

  def add
    add_to_cart
    redirect_to order_path
  end

  private

  def order_params
    params.require(:order).permit(:street, :city, :state, :zip)
  end
end
