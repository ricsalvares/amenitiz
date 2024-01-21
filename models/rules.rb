# frozen_string_literal: true

require 'yaml'
# Rule class
# It contains the rules to check whether a discount should be applied or not
#   - CEO rule: green tea(GR1) buy-1-get1-free for  ->
#   - COO rule: strawberries(SR1) >= 3 -> new_price 4.50€.
#   - VP of Engineering rule: coffee(CF1) >= 3 -> new_price 2/3
class Rules
  class WrongArgumentError < StandardError; end

  def initialize
    @rules = YAML.load_file('./config/rules.yml')
  end

  def for(product_code)
    @rules[product_code]
  end
end
