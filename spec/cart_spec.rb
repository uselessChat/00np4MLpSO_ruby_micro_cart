require './lib/cart'
require './lib/product'

RSpec.describe Cart, '#add_product' do
  it "should build product based on item line details" do
    cart = Cart.new
    item_line = '2 book at 12.49'
    product = cart.add_product(item_line)
    expect(product.description).to eq 'book'
    expect(product.quantity).to eq 2
    expect(product.price).to eq 12.49
  end
end

RSpec.describe Cart, '#taxes' do
  it 'should sum products taxes' do
    cart = Cart.new
    product_1 = Product.new('')
    product_1.instance_eval do
      def taxes; 1.47; end
    end
    product_2 = Product.new('')
    product_2.instance_eval do
      def taxes; 3.48; end
    end
    cart.products.push(product_1)
    cart.products.push(product_2)
    expect(cart.taxes).to eq 4.95
  end
end

RSpec.describe Cart, '#total' do
  it 'should sum products totals' do
    cart = Cart.new
    product_1 = Product.new('')
    product_1.instance_eval do
      def total; 15.53; end
    end
    product_2 = Product.new('')
    product_2.instance_eval do
      def total; 24.14; end
    end
    cart.products.push(product_1)
    cart.products.push(product_2)
    expect(cart.total).to eq 39.67
  end
end

RSpec.describe Cart, '#print_value_item_lines' do
  it 'should resolve printing message for each item line' do
    cart = Cart.new
    product_1 = Product.new('Product [1]', 15.53, 1)
    product_1.instance_eval do
      def total; 15.53; end
    end
    product_2 = Product.new('Product [2]', 12.12, 2)
    product_2.instance_eval do
      def total; 24.14; end
    end
    cart.products.push(product_1)
    cart.products.push(product_2)
    expect(cart.print_value_item_lines).to eq [
      '1 Product [1]: 15.53',
      '2 Product [2]: 24.14'
    ]
  end
end

RSpec.describe Cart, '#print_value_taxes' do
  it 'should resolve printing message for sales taxes' do
    cart = Cart.new
    cart.instance_eval do
      def taxes; 15.53; end
    end
    expect(cart.print_value_taxes).to eq 'Sales Taxes: 15.53'
  end
end

RSpec.describe Cart, '#print_value_total' do
  it 'should resolve printing message for sales total' do
    cart = Cart.new
    cart.instance_eval do
      def total; 54.71; end
    end
    expect(cart.print_value_total).to eq 'Total: 54.71'
  end
end