# frozen_string_literal: true

require 'forwardable'

module Services
  # DiscountCalculator Service: It calculates the discount for a given product, considering its amount and discount rule
  class DiscountCalculator
    class ProductCodeMismatchError < StandardError; end
    class WrongArgumentError < StandardError; end

    def initialize(product, amount, rule = nil)
      raise WrongArgumentError.new("Please provide a Product (#{product})") unless  product.is_a?(Product)
      raise WrongArgumentError.new("Please provide a Rule (#{rule})") if rule && !rule.is_a?(Rule)

      @product = product
      @amount = amount
      @rule = rule
    end

    def call
      return amount * product.price unless rule

      validate_product_code!
      apply_relative_discount || apply_absolute_discount
    end

    private

    attr_reader :rule, :product, :amount
    def apply_relative_discount
      return unless rule.relative_discount

      partial_amount = ((1 - rule.relative_discount) * amount)
      partial_amount = partial_amount.send(rule.round) if rule.round
      partial_amount * product.price
    end

    def apply_absolute_discount
      return unless rule.absolute_discount

      (product.price - rule.absolute_discount) * amount
    end

    def validate_product_code!
      return if product.code == rule.product_code

      raise ProductCodeMismatchError, "Rule cannot be applied to product: #{product}"
    end
  end
end
