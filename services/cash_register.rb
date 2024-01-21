# frozen_string_literal: true

require_relative '../models/store'

require 'forwardable'

module Services
  # Basket class: Used to scan and increment products count
  class CashRegister
    extend Forwardable

    class WrongArgumentError < StandardError; end
    class InvalidProductError < StandardError; end

    def initialize(store)
      raise WrongArgumentError, 'Please provide a valid store' unless store.is_a?(Store)

      @store = store
      @basket = Hash.new(0)
      @basket_of_products_in_order = [] # Used to print the products in the order they were scanned
    end

    def_delegator :store, :products
    def_delegator :store, :rules

    attr_reader :basket, :store

    def scan(product_code)
      validate_product!(product_code)
      add_to_basket(product_code)
      true
    end

    def total
      basket.reduce(0) do |sum, (code, count)|
        sum + (products[code].price * count)
      end
    end

    private

    def add_to_basket(product_code)
      @basket[product_code] += 1
      @basket_of_products_in_order << product_code
    end

    def validate_product!(product_code)
      return if products[product_code]

      raise InvalidProductError, "Invalid product: #{product_code}"
    end
  end
end
