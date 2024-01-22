# frozen_string_literal: true

require_relative '../models/store'
require_relative 'discount_rule_handler'

require 'forwardable'

module Services
  # CashRegister Service: Used to scan products, incrementing the products amount in a basket
  class CashRegister
    extend Forwardable

    class WrongArgumentError < StandardError; end
    class InvalidProductError < StandardError; end

    def initialize(store)
      raise WrongArgumentError, 'Please provide a valid store' unless store.is_a?(Store)

      @store = store
      @basket = Hash.new(0)
      @basket_of_products_in_order = [] # Used to print the products in the order they were scanned
      @discount_rule_handler = DiscountRuleHandler.new(store)
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
      basket.map do |code, amount|
        discount_rule_handler.apply_discount_for(code, amount)
      end.sum
         .round(2)
    end

    private

    attr_reader :discount_rule_handler

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
