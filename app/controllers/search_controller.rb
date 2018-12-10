class SearchController < ApplicationController

  def index
    @products = Amazon::Product.where("asin LIKE :search OR title LIKE :search", {search: "%#{params[:query]}%"})
    # Amazon Lookup if not found in the DB
    if @products.blank? && Amazon::Lookup::valid_ASIN(params[:query])
      code, product = Amazon::Lookup::ASIN(params[:query])
      if code == 200 # if found save, and return
        product.save!
        @products = [product]
      end
    end
  end
end
