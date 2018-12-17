require File.expand_path('../../test_helper', __FILE__)

class ProductsTest < ActionDispatch::IntegrationTest

  test 'ASIN present in the database' do
    get product_url(asin: '1250103509')

    assert_select 'h1.header', 'Radical Candor: Be a Kick-Ass Boss Without Losing Your Humanity'
    assert_select 'div.meta', 'Category Books Business & Money Business Culture'
  end

  test 'ASIN not present in the database' do
    get product_url(asin: 'xxyz')
    assert_response :not_found
  end
end
