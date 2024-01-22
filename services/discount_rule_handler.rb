# frozen_string_literal: true

require_relative '../models/store'
require_relative './discount_calculator'

require 'forwardable'

module Services
  # DiscountRuleHandler Service: Used to check whether a given product_code has any discount rule to be applied
  class DiscountRuleHandler
    extend Forwardable

    class WrongArgumentError < StandardError; end
    class InvalidProductError < StandardError; end

    def initialize(store)
      raise WrongArgumentError, 'Please provide a valid store' unless store.is_a?(Store)

      @store = store
    end

    def_delegator :store, :products
    def_delegator :store, :rules

    def apply_discount_for(code, amount)
      product = products[code]
      rule = rule_by(product, amount)
      DiscountCalculator.new(product, amount, rule).call
    end

    private

    def rule_by(product, amount)
      rules.find do |rule|
        rule.apply?(product.code, amount)
      end
    end

    attr_reader :store, :rules_to_be_applied
  end
end
