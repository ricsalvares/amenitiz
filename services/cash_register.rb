# frozen_string_literal: true

require_relative '../models/store'

# Basket class: Used to scan and count products to be purchased
class CashRegister
  extend Forwardable

  class WrongArgumentError < StandardError; end
  class InvalidProductError < StandardError; end
end
