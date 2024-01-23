# frozen_string_literal: true

require 'csv'
module Services
  # Class to handle input from STDIN
  class DefaultInputReader
    USAGE_MESSAGES = {
      product: "Type products code separate by semicolon (;)\nexample: CODE1;CODE2",
      expected_total: 'Type expected total amount: '
    }.freeze
    private_constant :USAGE_MESSAGES

    def read
      return [[@product_list, @expected_total]] if defined?(@product_list) && defined?(@expected_total)

      puts usage_message(:product)
      @product_list = gets.chomp

      print usage_message(:expected_total)
      @expected_total = gets.chomp

      [[@product_list, @expected_total]]
    end

    private

    def usage_message(code)
      USAGE_MESSAGES[code]
    end
  end
end
