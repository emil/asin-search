class Amazon::Lookup
  extend Amazon::ParserUtils
  URL_BASE = 'https://www.amazon.com/dp/'.freeze
  
  class << self
    # Lookup Amazon Product by ASIN via GET request to <tt>https://www.amazon.com/dp/<asin></tt>
    # Return the response code and the <tt>Amazon::Product</tt> instance with <tt>Amazon::ProductDetails</tt>
    #
    # Use CSS to extract following elements:
    #  - Product Title, Category
    #  - Product Details rank & product dimensions
    def ASIN(asin)
      return [400, nil] unless valid_ASIN(asin)
      begin
        client = http_client
        
        response = client.get(URL_BASE + asin, {follow_redirect: true}, headers)
        return [response.code, nil] unless response.code == 200 # unless OK, return

        product = Amazon::ProductParser.new(response.body, asin).product
        [200, product]
      rescue
        log.error ([$!.message]+$!.backtrace).join($/)
        return [500, nil]
      end
    end

    def valid_ASIN(asin)
      return false if asin.blank? || asin.length != 10
      return false unless asin =~ /\A[[:alnum:]]+\Z/ # must be alphanumeric

      true
    end
    
    private
    
    # Simulate known browser UA
    def headers
      {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36'}
    end

    # Instantiate the HTTP client, set timeouts
    def http_client
      client = HTTPClient.new
      client.connect_timeout = 20 # 20 seconds
      client.receive_timeout = 20 # 20 seconds
      client
    end
    
  end
end
