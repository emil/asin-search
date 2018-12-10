class CreateAmazonProductDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :amazon_product_details do |t|
      t.string :label
      t.string :value
      t.integer :product_id, index: true

      t.timestamps
    end
    add_foreign_key :amazon_product_details, :amazon_products, column: :product_id
  end
end
