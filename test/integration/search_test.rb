require File.expand_path('../../test_helper', __FILE__)

class SearchTest < ActionDispatch::IntegrationTest

  # ASIN not present in the database, results in the HTTP request
  # and stored in the DB
  test 'search ASIN not present in the database produces new record' do

    # delete record, trigger URL download
    Amazon::Product.where(asin: '1250103509').first.destroy

    # stub ASIN download from the fixtures
    expects_http_request('1250103509') # expects HTTP request
    
    assert_difference 'Amazon::Product.count', 1 do # records + 1
      get search_url(query: '1250103509')

      assert_select 'h1.header', '1250103509 (1 results)'
       assert_select 'a.item[href=?]', '/products/1250103509'

      assert_select 'div.header', 'Radical Candor: Be a Kick-Ass Boss Without Losing Your Humanity'
      assert_select 'div.description > p', 'Books Business & Money Business Culture'
    end
  end
  
  # ASIN present in the database, results in DB lookup
  # and no HTTP request
  test 'search ASIN present in the database' do
    
    expects_http_request('1250103509').never # no HTTP request expected!
    
    get search_url(query: '1250103509')

    assert_select 'h1.header', '1250103509 (1 results)'
    assert_select 'div.header', 'Radical Candor: Be a Kick-Ass Boss Without Losing Your Humanity'
    assert_select 'div.description > p', 'Books Business & Money Business Culture'
  end

  test 'search ASIN not present in the database' do
    expects_http_request('1250103509').never # no HTTP request, invalid ASIN format
    get search_url(query: 'xxyz')
    
    assert_select 'h1.header', 'xxyz (0 results)'
  end
end
