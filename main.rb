require './lib/product'
require './lib/cart'

items = []
puts "Input your items on each line and to finish just press 'ENTER' again"
input = gets.chomp
until input.size.zero?
  items.push(input)
  input = gets.chomp
end

cart = Cart.new
items.each do |item|
  cart.add_product(item)
end
cart.print
