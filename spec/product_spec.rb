require './lib/product'

RSpec.describe Product, '#imported?' do
  context "when product description don't include 'imported' label" do
    it 'should resolves to false' do
      model = Product.new('[Test]')
      expect(model.imported?).to eq false
    end
  end

  context "when product description include 'imported' label" do
    it 'should resolves to false' do
      model = Product.new('[Test] imported')
      expect(model.imported?).to eq true
    end
  end
end

RSpec.describe Product, '#subtotal' do
  context "with quantity: 1 and price 13" do
    it 'should resolve 13' do
      model = Product.new('[NA]', 13, 1)
      expect(model.subtotal).to eq 13
    end
  end

  context "with quantity: 2 and price 15" do
    it 'should resolve 30' do
      model = Product.new('[NA]', 15, 2)
      expect(model.subtotal).to eq 30
    end
  end
end

RSpec.describe Product, '#tax_base' do
  context "when product is exempted for base tax" do
    it 'should resolve to 0' do
      model = Product.new('[Test] book')
      expect(model.tax_base).to eq 0
    end
  end
  
  context "when product is not exempted for base tax" do
    it 'should resolve with 10% based on subtotal := 15' do
      model = Product.new('[Test]', 1, 15)
      expect(model.tax_base).to eq 1.5
    end
  end
end

RSpec.describe Product, '#tax_exempt?' do
  context "when product type 'book'" do
    it 'should resolve to true' do
      model = Product.new('[Test] book')
      expect(model.tax_exempt?).to eq true
    end
  end

  context "when product type 'food'" do
    it 'should resolve to true' do
      model = Product.new('[Test] chocolates')
      expect(model.tax_exempt?).to eq true
    end
  end

  context "when product type 'medical'" do
    it 'should resolve to true' do
      model = Product.new('[Test] pills')
      expect(model.tax_exempt?).to eq true
    end
  end

  context "when product is not type: book, food or medical" do
    it 'should resolve to false' do
      model = Product.new('[Test]')
      expect(model.tax_exempt?).to eq false
    end
  end
end

RSpec.describe Product, '#tax_imported' do
  context 'when product was not imported' do
    it 'should resolve to 0' do
      model = Product.new('[Test]')
      expect(model.tax_imported).to eq 0
    end
  end

  context 'when product was imported' do
    it 'should resolve to 5% based on subtotal := 15' do
      model = Product.new('[Test] imported', 1, 15)
      expect(model.tax_imported).to eq 0.75
    end
  end
end

RSpec.describe Product, '#taxes' do
  context "when product is exempt and not imported" do
    it 'should resolve to 0' do
      model = Product.new('[Test] book', 1, 15)
      expect(model.taxes).to eq 0
    end
  end

  context "when product is exempt and imported" do
    it 'should resolve to 0.75 based on subtotal := 15' do
      model = Product.new('[Test] book imported', 1, 15)
      expect(model.taxes).to eq 0.75
    end
  end

  context "when product is not exempt and imported" do
    it 'should resolve to 2.25 based on subtotal := 15' do
      model = Product.new('[Test] imported', 1, 15)
      expect(model.taxes).to eq 2.25
    end
  end

  context "taxes round to nearest 0.5" do
    it 'should resolve 2.30 when tax base 1 & imported 1.288' do
      model = Product.new('[Test]')
      model.instance_eval do
        def tax_base; 1; end
        def tax_imported; 1.288; end
      end
      expect(model.total).to eql 2.30
    end
  end

  context "taxes round to nearest 0.5" do
    it 'should resolve 2.25 when tax base 1 & imported 1.245' do
      model = Product.new('[Test]')
      model.instance_eval do
        def tax_base; 1; end
        def tax_imported; 1.245; end
      end
      expect(model.total).to eql 2.25
    end
  end
end

RSpec.describe Product, '#total' do
  it "should resolve 17.25 with subtotal := 15 & taxes := 2.25" do
    model = Product.new('[Test]')
    model.instance_eval do
      def subtotal; 15; end
      def taxes; 2.25; end
    end
    expect(model.total).to eql 17.25
  end

  it "should resolve 17.22 with subtotal := 15 & taxes := 2.22" do
    model = Product.new('[Test]')
    model.instance_eval do
      def subtotal; 15; end
      def taxes; 2.222; end
    end
    expect(model.total).to eql 17.22
  end

  it "should resolve 17.28 with subtotal := 15 & taxes := 2.28" do
    model = Product.new('[Test]')
    model.instance_eval do
      def subtotal; 15; end
      def taxes; 2.28; end
    end
    expect(model.total).to eql 17.28
  end
end