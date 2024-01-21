# frozen_string_literal: true

require 'yaml'
# Rule class
# It contains the rules to check whether a discount should be applied or not
#   - CEO rule: green tea(GR1) buy-1-get1-free for  ->
#   - COO rule: strawberries(SR1) >= 3 -> new_price 4.50€.
#   - VP of Engineering rule: coffee(CF1) >= 3 -> new_price 2/3
class Rule
  class WrongArgumentError < StandardError; end
  class ProductCodeMismatchError < StandardError; end

  class << self
    def load_rules_from_config_file
      rules = YAML.load_file('./config/rules.yml')
      rules.map do |code, attributes|
        Rule.new(product_code: code, **attributes.transform_keys(&:to_sym))
      end
    end
  end

  def initialize(params)
    @round = params[:round]&.to_sym || :floor
    @product_code = params[:product_code]
    @min_amount = params[:min_amount]
    @name = params[:name]
    @relative_discount = params[:relative_discount]
    @absolute_discount = params[:absolute_discount]
  end

  attr_reader :round, :min_amount, :name, :relative_discount, :absolute_discount, :product_code

  def apply?(code, amount)
    product_code == code && amount >= min_amount
  end

  def apply_discount(...)
    validate_product_code!(...)
    apply_relative_discount(...) || apply_absolute_discount(...)
  end

  private

  def apply_relative_discount(product, amount)
    return unless relative_discount

    partial_amount = ((1 - relative_discount) * amount)
    partial_amount.send(round || :ceil) * product.price
  end

  def apply_absolute_discount(product, amount)
    return unless absolute_discount

    (product.price - absolute_discount) * amount
  end

  def validate_product_code!(product, _)
    return if product.code == product_code

    raise ProductCodeMismatchError, "Rule cannot be applied to product: #{product}"
  end
end
