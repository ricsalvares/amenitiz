# frozen_string_literal: true

require_relative '../models/product'
require_relative '../models/store'
require_relative 'cash_register'
module Services
  # Class to run the cash register
  class CashRegisterRunner
    def initialize(input_handler)
      @input_handler = input_handler
    end

    def run
      products = init_products
      store = init_store(products)
      input_handler.read.each do |product_list, expected_total|
        cr = init_cash_register_service(store)
        product_list.split(';').each { cr.scan(_1) }
        p "products: #{product_list} | €#{cr.total}  (expected €#{expected_total})"
      end
      nil
    end

    private

    def init_cash_register_service(store)
      Services::CashRegister.new(store)
    end

    def init_products
      Product.load_products_from_config_file
    end

    def init_store(products)
      Store.new(products:)
    end

    attr_reader :input_handler
  end
end
