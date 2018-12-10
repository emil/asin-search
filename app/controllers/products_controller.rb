class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  # GET /products
  # GET /products.json
  def index
    @products = Amazon::Products.all
  end

  # GET /products/B0753H4B6M
  # GET /products/B0753H4B6M.json
  def show
  end


  private

  def set_product
    @product = Amazon::Product.where(asin: params[:asin]).first
  end

end
