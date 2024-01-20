#!/usr/bin/env ruby
# frozen_string_literal: true

#   - Check the file structures (how to load them....)
require 'pry'
require 'yaml'

# CashRegisterRunner class
class CashRegisterRunner
  def run
    # Sketch of workflow
    # product_list = [] #... input data for new products
    # products = product_list.map { |params| Product.new(**params) }
    # store = Store.new(products)
    # b1 = Basket.new(store)
    # input_products_to_be_scanned = [] #...
    # input_products_to_be_scanned.each { |product| b1.scan(product) }
    # b1.total() # == discounts applied
    # b1.gross_total() # without discount
    'Ran!'
  end
end

puts 'running'
puts CashRegisterRunner.new.run
