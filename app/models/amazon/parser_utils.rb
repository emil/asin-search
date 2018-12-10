module Amazon::ParserUtils
  protected
  # Whether the label should be included,
  # requirements is 'Product Dimensions' and 'Amazon Best Sellers Rank'
  def include_details_label?(label)
    is_product_dimensions?(label) || is_sellers_rank?(label)
  end

  def is_product_dimensions?(label)
    label =~ /\A\s*Product Dimensions/
  end

  def is_sellers_rank?(label)
    label =~ /\A\s*Amazon Best Sellers Rank/ ||
      label =~ /\A\s*Best Sellers Rank/
  end

  # Some values require additional formatting
  
  def format_details_value(label, value)
    if is_sellers_rank?(label)
      return format_sellers_rank_value(value)
    end
    value
  end

  # sellers rank, reformat; loose the '(See Top 100)' and add the space character
  # before the 'in' in case it got lost. For example : '#100in Books' => '#100 in Books'
  # additionally add ', ' before the segments (split by '#')
  def format_sellers_rank_value(value)
    formatted_value = value.gsub(/\s*\([^\)]*\)\s*/, '').gsub /#(\d+)in/, '#\1 in'
    formatted_value = formatted_value.split('#')
    formatted_value.shift # loose first element ""
    formatted_value = '#' + formatted_value.join(', #')
    
    log.info "Formatting 'Sellers Rank' '#{value}' to '#{formatted_value}'"
    formatted_value
  end
  
  # clean label string; remove trailing ':' if present
  def clean_label(label)
    clean_value(label).gsub /:\Z/, ''
  end

  # clean string; remove leading whitespace, replace contiguous whitespace
  # with single whitespace.
  # See +String#split+
  def clean_value(value)
    value.split.join(' ')
  end

  def log
    ActiveRecord::Base.logger
  end
end
