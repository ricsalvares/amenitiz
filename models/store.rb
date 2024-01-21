# frozen_string_literal: true

require_relative 'product'
# Store: A class to store the products, and discount rules
class Store
  class WrongArgumentError < StandardError; end
  class InvalidProductError < StandardError; end

  def initialize(products: [], rules: [])
    products.each { raise WrongArgumentError, "Invalid product #{_1}" unless _1.is_a?(Product) }
    @products = products.each_with_object({}) { |product, hash| hash[product.code] = product }
    @rules = rules
  end

  attr_reader :products, :rules

  def register_product(product)
    raise InvalidProductError, "Invalid #{Product}" unless product.is_a? Product

    @products[product.code] = product
  end
end
