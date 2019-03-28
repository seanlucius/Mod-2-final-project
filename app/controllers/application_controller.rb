class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  def cart
    session[:cart] ||= []
  end

  def add_to_cart
    # Get the item from the path
    @product = Product.find(params[:id])
    # Load the cart from the session, or create a new empty cart.
    cart << @product.id
  end
end
