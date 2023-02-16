class Product
  attr_reader :description, :price, :quantity

  def initialize(description, price = 0, quantity = 0)
    @description = description
    @price = price
    @quantity = quantity
  end

  def imported?
    description.include? 'imported'
  end

  def subtotal
    price * quantity
  end

  def tax_base
    return 0 if tax_exempt?

    subtotal * 0.10
  end

  def tax_exempt?
    exempt = %w[book chocolate pill]
    compare = description.downcase
    exempt.any? { |product_type| compare.include? product_type }
  end

  def tax_imported
    return 0 unless imported?

    subtotal * 0.05
  end

  def taxes
    value = tax_base + tax_imported
    (value * 20).round / 20.0
  end

  def total
    (subtotal + taxes).round(2)
  end
end
