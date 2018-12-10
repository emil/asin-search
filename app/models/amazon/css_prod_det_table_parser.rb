# Parse +<li>+ nodes, the +#div#prodDetails tbody > tr</tt> table, +<th>+ is a *label*
# and the +<td>+ is a *value).
#
module Amazon
  class CssProdDetTableParser
    include Amazon::ParserUtils
    
    private
    def initialize(details_node, product)
      read_details_css_prod_det_table(details_node, product)
    end
    
    def read_details_css_prod_det_table(details_node, product)
      label_value = details_node.map do |tr|
        [clean_label(tr.css('> th').text), clean_value(tr.css('> td').text)]
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
