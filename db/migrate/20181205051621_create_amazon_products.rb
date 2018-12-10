class CreateAmazonProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :amazon_products do |t|
      t.string :asin, limit: 10
      t.string :title
      t.string :category
      t.string :image_url
      t.references :account, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :amazon_products, :asin, unique: true
  end
end
