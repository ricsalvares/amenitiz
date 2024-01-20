#!/usr/bin/env ruby
# frozen_string_literal: true

#   TODO:
#   - Class/Service to read/parse input data (don't forget validators; reading from stdin? file?)
#   - Class/service to register products in the basket
#   - Class/Service to display data/basket
#   - Class/Service to calculate/check/manage the rules/eligibility for a discount
#   - Class/Service with configuration setup (price tables, codes, perhaps discount rules)
#   - Class to run everything (workflow)
#     - scan product
#
#   - Check the file structures (how to load them....)

# CashRegisterRunner class
class CashRegisterRunner
  def run
    'Ran!'
  end
end

puts 'running'
puts CashRegisterRunner.new.run
