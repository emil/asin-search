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
    product_details.find {|d| labels.include?(d.label) }&.value || 'Unknown'
  end

  def dimensions
    product_details.find {|d| d.label == 'Product Dimensions'}&.value || 'Unknown'
  end

  def to_fixture_yaml
    [asin,
     {title: title,
      category: category,
      image_url: image_url,
      dimensions: dimensions,
      ranking: ranking}
    ].to_yaml
  end
  
  before_validation do
    self.account = RequestRegistry.current_account
    self.user    = RequestRegistry.current_user
  end
end
