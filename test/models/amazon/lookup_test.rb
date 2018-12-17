# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Amazon::LookupTest < ActiveSupport::TestCase

  # basic argument check test
  test "asin blank bad argument" do

    assert_equal [400, nil], Amazon::Lookup::ASIN(nil)
    assert_equal [400, nil], Amazon::Lookup::ASIN('')
  end

  # basic argument check test
  test "asin required to be alphanumeric" do
    
    assert_equal [400, nil], Amazon::Lookup::ASIN('-_@#$%7890')
  end

  # parsing test '#prodDetails > div.wrapper > div.column.col1 > div > div.content > div > div > table tr'
  test "read details as css id prodDetails" do

    stub_http_request('B002QYW8LW')
    response_code, product = Amazon::Lookup::ASIN('B002QYW8LW')
    assert_equal 200, response_code

    assert_equal 'B002QYW8LW', product.asin
    assert_equal 'Baby Banana Infant Training Toothbrush and Teether, Yellow', product.title
    assert_equal 'Baby Products Baby Care Pacifiers, Teethers & Teething Relief Teethers', product.category
    assert_equal 'https://images-na.ssl-images-amazon.com/images/I/71vLVbAlWXL._SL1500_.jpg', product.image_url
    # expect product dimensions
    assert_equal [
      ['Product Dimensions', '4.3 x 0.4 x 7.9 inches'],
      ["Best Sellers Rank", "#83 in Baby, #5 in Baby > Baby Care > Pacifiers, Teethers & Teething Relief > Teethers, #14 in Baby > Baby Care > Health"]
    ], product.product_details.map {|d| [d.label, d.value]}
  end

  # parsing test CSS #productDetailsTable div.content ul > li
  test "read details as css id productDetailsTable" do

    stub_http_request('1250103509')
    response_code, product = Amazon::Lookup::ASIN('1250103509')
    assert_equal 200, response_code

    assert_equal '1250103509', product.asin
    assert_equal 'Radical Candor: Be a Kick-Ass Boss Without Losing Your Humanity', product.title
    assert_equal 'Books Business & Money Business Culture', product.category
    assert_equal 'https://images-na.ssl-images-amazon.com/images/I/411O8D1w2UL._SY291_BO1,204,203,200_QL40_.jpg', product.image_url
    # expect product dimensions
    assert_equal [
      ['Product Dimensions', '6.4 x 1 x 9.5 inches'],
      ["Amazon Best Sellers Rank", "#981 in Books, #2 in Books > Business & Money > Management & Leadership > Management Science, #2 in Books > Business & Money > Business Culture > Workplace Culture, #3 in Books > Business & Money > Human Resources > Human Resources & Personnel Management"]
    ], product.product_details.map {|d| [d.label, d.value]}
  end

end
