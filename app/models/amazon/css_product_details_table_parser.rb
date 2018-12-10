# Parse +<li>+ nodes, the +#productDetailsTable</tt> table, +<b>+ is a *label*
# and the rest of the siblings are a *value).
#
# The CSS selector is: #productDetailsTable div.content ul > li, and the sample
# content is:
#
# <li>
#   <b>Hardcover:</b> 272 pages</li>
# <li>
#   <b>Publisher:</b> St. Martin's Press; 1 edition (March 14, 2017)</li>
# <li>
#   <b>Language:</b> English</li>
# <li>
#   <b>ISBN-10:</b> 1250103509</li>
# <li>
#   <b>ISBN-13:</b> 978-1250103505</li>
# <li>
#   <b>    Product Dimensions:     </b>    6.4 x 1 x 9.5 inches    </li>
# <li>
# Returns +true+ when the details were read in, +false+ otherwise.
 
module Amazon
  class CssProductDetailsTableParser
    include Amazon::ParserUtils
    
    private
    def initialize(details_node, product)
      read_details_css_product_details_table(details_node, product)
    end
    
    def read_details_css_product_details_table(details, product)
      # 'b' is the label
      # rest of the siblings are the value
      label_value = details.css('> b').map do |e|
        [
          clean_label(e.text),
          e.ancestors.first.children.slice(1..-1).map do |e|
            clean_value(e.text)
          end.join
        ]
      end
      
      label_value.each do |label, value|
        if include_details_label?(label)
          product.product_details.build(label: label, value: format_details_value(label, value))
        end
      end
      
      true
    end
  end
end
