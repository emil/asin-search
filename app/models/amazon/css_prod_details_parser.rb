# Parse each +<td>+ pair as product details key,value pair and populate
# the supplied +Product+ instance.
#
# This parser parses the CSS :
# #prodDetails > div.wrapper > div.column.col1 > div > div.content > div > div > table > tbody > tr
#
# Sample HTML fragment:
# <tt>
# <tbody>
#   <tr class="size-weight"><td class="label">Item Weight</td><td class="value">1.44 ounces</td></tr>
#   <tr><td class="label">Number of items</td><td class="value">1</td></tr>
#   <tr><td class="label">Batteries required</td><td class="value">No</td></tr>
#   <tr><td class="label">Dishwasher safe</td><td class="value">No</td></tr>
#   <tr><td class="label">Is portable</td><td class="value">No</td></tr>
#   <tr><td class="lAttr">&nbsp;</td><td class="lAttr">&nbsp;</td></tr>
#</tbody>
# </tt>
# Returns +true+ when the details were read in, +false+ otherwise.

module Amazon
  class CssProdDetailsParser
    include Amazon::ParserUtils
    
    private
    def initialize(details_node, product)
      read_details_css_prod_details(details_node, product)
    end
    
    def read_details_css_prod_details(details_node, product)
      # label, value pair <td> nodes
      details_node.children.map {|e| e.text}.each_slice(2) do |e|
        if e.last.present? # exclude blank values
          label = clean_label(e.first)
          value = clean_value(e.last)
          if include_details_label?(label)
            product.product_details.build(label: label, value: format_details_value(label, value))
          end
        end
      end
      true
    end
  end
end
