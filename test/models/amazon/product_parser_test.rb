# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Amazon::ProductParserTest < ActiveSupport::TestCase

  setup do
    # Product belongs to account, user, set in the Product#before_validation
    RequestRegistry.current_user = User.first
    RequestRegistry.current_account = User.first.account
  end

  # parsing test '#prodDetails > div.wrapper > div.column.col1 > div > div.content > div > div > table tr'
  test "read details as css id prodDetails" do

    product = Amazon::ProductParser.new(read_fixture_file('B002QYW8LW')).product

    assert_equal 'B002QYW8LW', product.asin
    assert_equal 'Baby Banana Infant Training Toothbrush and Teether, Yellow', product.title
    assert_equal 'Baby Products Baby Care Pacifiers, Teethers & Teething Relief Teethers', product.category
    assert_equal 'https://images-na.ssl-images-amazon.com/images/I/71vLVbAlWXL._SL1500_.jpg', product.image_url
    # expect product dimensions
    assert_equal [
      ['Product Dimensions', '4.3 x 0.4 x 7.9 inches'],
      ["Best Sellers Rank", "#83 in Baby, #5 in Baby > Baby Care > Pacifiers, Teethers & Teething Relief > Teethers, #14 in Baby > Baby Care > Health"]
    ], product.product_details.map {|d| [d.label, d.value]}

    assert product.valid?
  end

  # parsing test table.prodDetTable tr
  test "read details as css id prodDetails Exploding Kittens" do

    product = Amazon::ProductParser.new(read_fixture_file('B010TQY7A8')).product

    assert_equal 'B010TQY7A8', product.asin
    assert_equal 'Exploding Kittens Card Game', product.title
    assert_equal 'Toys & Games Games Card Games', product.category
    assert_equal 'https://images-na.ssl-images-amazon.com/images/I/91mSHaL6oEL._SL1500_.jpg', product.image_url
    # expect product dimensions
    assert_equal [
      ['Product Dimensions', '11.2 x 16.2 x 3.8 inches'],
      ["Best Sellers Rank", "#14 in Toys & Games, #1 in Amazon Launchpad >Toys, #1 in Toys & Games >Games >Card Games"]
    ], product.product_details.map {|d| [d.label, d.value]}

    assert product.valid?
  end

  # parsing test table.prodDetTable tr
  test "read details as css id prodDetails External Hard Drive" do

    product = Amazon::ProductParser.new(read_fixture_file('B0046UR4F4')).product

    assert_equal 'B0046UR4F4', product.asin
    assert_equal 'G-Technology G-SPEED eS PRO High-Performance Fail-Safe RAID Solution for HD/2K Production 8TB (0G01873)', product.title
    assert_equal 'Electronics Computers & Accessories Data Storage External Hard Drives', product.category
    assert_equal 'https://images-na.ssl-images-amazon.com/images/I/717HFf5wbWL._SL1248_.jpg', product.image_url
    # expect product dimensions
    assert_equal [
      ['Product Dimensions', '4.9 x 8.3 x 6.5 inches'],
      ["Best Sellers Rank", "#6,389 in Computers & Accessories >Data Storage >External Hard Drives"]
    ], product.product_details.map {|d| [d.label, d.value]}

    assert product.valid?
  end

  test "read details image is landingImage src" do
    
    product = Amazon::ProductParser.new(read_fixture_file('B00UZKG8QU')).product

    assert_equal 'B00UZKG8QU', product.asin
    assert_equal 'G-Technology G-RAID USB Removable Dual Drive Storage System 8TB (0G04069)', product.title
    assert_equal 'Electronics Computers & Accessories Data Storage', product.category
    assert_equal 'https://images-na.ssl-images-amazon.com/images/I/41zDevK42BL._SY300_QL70_.jpg', product.image_url
    # expect product dimensions
    assert_equal [
      ['Product Dimensions', '5.1 x 9.9 x 3.6 inches'],
      ["Best Sellers Rank", "#13,211 in Computers & Accessories >Data Storage"]
    ], product.product_details.map {|d| [d.label, d.value]}

    assert product.valid?
    
  end
  
  # parsing test CSS #productDetailsTable div.content ul > li
  test "read details as css id productDetailsTable" do

    product = Amazon::ProductParser.new(read_fixture_file('1250103509')).product

    assert_equal '1250103509', product.asin
    assert_equal 'Radical Candor: Be a Kick-Ass Boss Without Losing Your Humanity', product.title
    assert_equal 'Books Business & Money Business Culture', product.category
    assert_equal 'https://images-na.ssl-images-amazon.com/images/I/411O8D1w2UL._SY291_BO1,204,203,200_QL40_.jpg', product.image_url
    # expect product dimensions
    assert_equal [
      ['Product Dimensions', '6.4 x 1 x 9.5 inches'],
      ["Amazon Best Sellers Rank", "#981 in Books, #2 in Books > Business & Money > Management & Leadership > Management Science, #2 in Books > Business & Money > Business Culture > Workplace Culture, #3 in Books > Business & Money > Human Resources > Human Resources & Personnel Management"]
    ], product.product_details.map {|d| [d.label, d.value]}

    assert product.valid?
  end


  # parsing test table.prodDetTable tr
  test "read details as css id prodDetails HappySun Lettuce" do

    product = Amazon::ProductParser.new(read_fixture_file('B0753H4B6M')).product

    assert_equal 'B0753H4B6M', product.asin
    assert_equal 'HappySUN Pack of 2 Green Lettuce Artificial Lifelike Simulation PU Artificial Vegetables Fake Vegetable Home Kitchen Cabinet Decoration (2, Green Lettuce)', product.title
    assert_equal 'Home & Kitchen Home Décor Artificial Plants & Flowers Artificial Vegetables', product.category
    assert_equal 'https://images-na.ssl-images-amazon.com/images/I/51E8k60wERL._SL1000_.jpg', product.image_url
    # expect product dimensions
    assert_equal [
      ['Product Dimensions', '9.1 x 7.9 x 3.1 inches'],
      ["Best Sellers Rank", "#1,070,963 in Home & Kitchen, #104 in Home & Kitchen >Home Décor >Artificial Plants & Flowers >Artificial Vegetables"]
    ], product.product_details.map {|d| [d.label, d.value]}

    assert product.valid?
  end

  # parsing test html with binary zeros 
  test "read details html has binary zeros" do
    product_file = read_fixture_file('B00005C5H4')
    assert_match /\x00/, product_file # binary zeros
    product = Amazon::ProductParser.new(product_file).product

    assert_equal 'B00005C5H4', product.asin
    assert_equal 'The First Years Stack Up Cups', product.title
    assert_equal 'Toys & Games Baby & Toddler Toys Stacking & Nesting Toys', product.category
    assert_equal 'https://images-na.ssl-images-amazon.com/images/I/51R0kZwuwbL._SL1000_.jpg', product.image_url
    # expect product dimensions
    assert_equal [
      ['Product Dimensions', '3.5 x 3.2 x 2.5 inches'],
      ["Best Sellers Rank", "#1 in Baby, #1 in Toys & Games >Baby & Toddler Toys >Stacking & Nesting Toys, #5 in Toys & Games >Preschool"]
    ], product.product_details.map {|d| [d.label, d.value]}

    assert product.valid?
  end

  # #detail-bullets > table > tbody > tr > td > div.content > ul >
  test "read details as css id detail-bullets" do
    product_file = read_fixture_file('B00HXGSBXC')
    product = Amazon::ProductParser.new(product_file, 'B00HXGSBXC').product

    assert_equal 'B00HXGSBXC', product.asin
    assert_equal 'RoyalBaby BMX Freestyle Kid\'s Bike, 12-14-16-18-20 inch wheels, six colors available', product.title
    assert_equal 'Sports & Outdoors Outdoor Recreation Cycling Kids\' Bikes & Accessories Kids\' Bikes', product.category
    assert_equal 'https://images-na.ssl-images-amazon.com/images/I/817ru30ZLEL._SL1500_.jpg', product.image_url
    # expect product dimensions
    assert_equal [
      ['Product Dimensions', '35 x 19 x 25 inches ; 19 pounds'],
      ["Amazon Best Sellers Rank", "#189 in Sports & Outdoors, #1 in Sports & Outdoors > Outdoor Recreation > Cycling > Kids' Bikes & Accessories > Kids' Bikes, #1 in Amazon Launchpad > Gadgets > Sports & Outdoors, #1 in Sports & Outdoors > Outdoor Recreation > Cycling > Kids' Bikes & Accessories > Kids' Balance Bikes"]
    ], product.product_details.map {|d| [d.label, d.value]}

    assert product.valid?
  end
end
