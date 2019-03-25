class OrdersController < ApplicationController

  def show
    @cart = cart
  end

  def add
    add_to_cart
    redirect_to order_path
  end
end
