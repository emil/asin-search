class Amazon::Product < ApplicationRecord
  belongs_to :account
  belongs_to :user

  has_many   :product_details

  validates_presence_of :title, :category, :image_url, :product_details

  # Override resources 'products/:id' to 'products/:asin'
  def to_param
    asin
  end
  
  def ranking
    labels = ['Amazon Best Sellers Rank','Best Sellers Rank']
    product_details.where(label: labels).first&.value || 'Unknown'
  end

  def dimensions
    product_details.where(label: 'Product Dimensions').first&.value || 'Unknown'
  end
  
  before_validation do
    self.account = RequestRegistry.current_account
    self.user    = RequestRegistry.current_user
  end
end
