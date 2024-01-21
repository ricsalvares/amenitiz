# frozen_string_literal: true

require 'yaml'
# Rule class
# It contains the rules to check whether a discount should be applied or not
#   - CEO rule: green tea(GR1) buy-1-get1-free for  ->
#   - COO rule: strawberries(SR1) >= 3 -> new_price 4.50€.
#   - VP of Engineering rule: coffee(CF1) >= 3 -> new_price 2/3
class Rule
  class WrongArgumentError < StandardError; end

  class << self
    def load_rules_from_config_file
      rules = YAML.load_file('./config/rules.yml')
      rules.map do |code, attributes|
        Rule.new(product_code: code, **attributes.transform_keys(&:to_sym))
      end
    end
  end

  def initialize(params)
    @round = params[:round]
    @product_code = params[:product_code]
    @min_amount = params[:min_amount]
    @name = params[:name]
    @relative_discount = params[:relative_discount]
    @absolute_discount = params[:absolute_discount]
  end

  attr_reader :round, :min_amount, :name, :relative_discount, :absolute_discount, :product_code
end
