# Parse the Product 'Header' and the Product Details.

module Amazon
  class ProductParser
    include Amazon::ParserUtils
    
    # Parsed +Product+ instance
    attr_reader :product

    private
    
    def initialize(document, asin = nil)
      @document = parse_html(document)
      @asin = asin
      
      @product = read_product
      read_details
    end
    
    CSS_PRODUCT_TITLE      = '#productTitle'.freeze

    CSS_ASIN               = 'input#ASIN'.freeze

    CSS_PRODUCT_CATEGORY   = 'a.a-link-normal.a-color-tertiary'.freeze
    
    def read_product
      if @asin.blank?
        @asin = @document.css(CSS_ASIN)&.attribute('value')
      end
      # read the title and category and the image url
      title = @document.css(CSS_PRODUCT_TITLE)&.text
      title = clean_value(title) if title.present?
      category  = @document.css(CSS_PRODUCT_CATEGORY).map {|e| clean_value(e.text)}.join(' ')
      image_url = read_image_url
      
      Amazon::Product.new(asin: @asin, title: title, category: category, image_url: image_url)
    end

    # Known Product Details CSS Selectors 
    CSS_PROD_DET_TABLE = 'table.prodDetTable tr'.freeze

    CSS_PROD_DETAILS = '#prodDetails > div.wrapper > div.column > div > div.content > div > div > table tr'.freeze

    CSS_PRODUCT_DETAILS_TABLE = '#productDetailsTable div.content ul > li'.freeze
    CSS_DETAIL_BULLETS = '#detail-bullets > table tr > td > div.content > ul > li'.freeze
    
    # Mapping CSS Selector => parser class.
    DETAILS_PARSERS = {
      CSS_PROD_DET_TABLE => Amazon::CssProdDetTableParser,
      CSS_PROD_DETAILS   => Amazon::CssProdDetailsParser,
      CSS_PRODUCT_DETAILS_TABLE => Amazon::CssProductDetailsTableParser,
      CSS_DETAIL_BULLETS => Amazon::CssProductDetailsTableParser
    }.freeze

    # Read product details, try different strategies / different product layout pages.
    # The CSS selector maps to the class that parses the HTML product
    # details fragment.
    def read_details
      DETAILS_PARSERS.each do |css_selector, parser|
        details = @document.css(css_selector)
        if details.present?
          log.debug "ASIN: #{@product.asin}, Details CSS: '#{css_selector}' found."
          parser.new(details, @product)
          return
        end
      end
      log.warn "Unable to read product details, ASIN : '#{product.asin}'"
    end

    CSS_LANDING_IMAGE  = '#landingImage'.freeze
    CSS_IMG_BLK_FRONT  = '#imgBlkFront'.freeze

    def read_image_url
      n = @document.css(CSS_LANDING_IMAGE)
      if n.present?
        image_url = n.attribute('data-old-hires').value
        return image_url if image_url.present?
        return n.attribute('src').value
      end
      
      n = @document.css(CSS_IMG_BLK_FRONT)
      return n.attribute('src').value if n.present?
      nil
    end

    # remove 'style' and 'script' nodes, newlines, whitespace and binary zeros
    def parse_html(html)
      cleaned = html.gsub(/\n/, '').gsub(/>\s*</m, '><').gsub /\x00/, ''
      doc = Nokogiri::HTML(cleaned, nil, nil, Nokogiri::XML::ParseOptions.new.default_html.noblanks)
      # remove all 'script' and 'style' nodes from the document
      doc.css('style').each {|n| n.remove }
      doc.css('script').each {|n| n.remove }
      doc
    end
  end
end
