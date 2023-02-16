class Cart
  def products
    @products ||= []
  end

  def add_product(input)
    elements = input.split(' ')
    quantity = Integer(elements.shift)
    price = Float(elements.pop)
    elements.delete('at')
    description = elements.join(' ')
    product = Product.new(description, price, quantity)
    products.push(product)
    product
  end

  def taxes
    products.map(&:taxes).reduce(&:+)
  end

  def total
    products.map(&:total).reduce(&:+)
  end

  def print
    puts print_value_item_lines
    puts print_value_taxes
    puts print_value_total
  end

  def print_value_item_lines
    products.map do |item|
      "#{item.quantity} #{item.description}: #{format_value(item.total)}"
    end
  end
  
  def print_value_taxes
    "Sales Taxes: #{format_value(taxes)}"
  end

  def print_value_total
    "Total: #{format_value(total)}"
  end

  def format_value(value)
    format('%.2f', value)
  end
end