class CartsController < ApplicationController

  def index
    @cart = cart
  end

  def create
    @cart = cart
    add_to_cart
    redirect_to carts_path
  end

end
