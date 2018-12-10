json.extract! product, :id, :asin, :title, :image_url, :category, :ranking, :created_at, :updated_at
json.url product_url(product, format: :json)
