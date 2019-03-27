class CartsController < ApplicationController

  def index
    @cart = cart
  end

  def create
    @cart = cart
    add_to_cart
    redirect_to carts_path
  end

  def remove_item
    cart.delete_at(cart.find_index(params[:id].to_i))
    redirect_to carts_path
  end


end
