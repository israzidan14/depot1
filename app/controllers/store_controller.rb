class StoreController < ApplicationController

  skip_before_action :authorize
  
  include CurrentCart

  before_action :set_cart

  def index
	@products = Product.order(:title)
	session[:counter] ||= 0;
	session[:counter] += 1;
  end
  
end
