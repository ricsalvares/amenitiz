# frozen_string_literal: true

require_relative '../../services/discount_calculator'
require_relative '../../models/store'
require_relative '../../models/product'

require 'yaml'
require 'spec_helper'

RSpec.describe Services::DiscountCalculator do
  subject(:calculator) { described_class.new(*params) }
  let(:params) {[product, amount, rule ]}
  let(:product) { Product.new(name: "product 1", price: 1.4, code: product_code) }
  let(:amount) { 5 }
  let(:product_code) { 'cod1' }
  let(:rule) {Rule.new(**rule_params)}
  let(:rule_params) do
    { product_code: product_code,
      min_amount: amount
    }
  end

  describe 'initialize' do
    context 'when product it not provided' do
      let(:product) { nil }
      it 'raises error' do
        expect { subject }.to raise_error Services::DiscountCalculator::WrongArgumentError
      end
    end

    context 'when rule provided is not ::Rule' do
      let(:rule) { 1 }
      it 'raises error' do
        expect { subject }.to raise_error Services::DiscountCalculator::WrongArgumentError
      end
    end
  end

  describe '#call' do
    context 'when the rule provided does not match the product' do
      let(:rule) { Rule.new(relative_discount: 0.5 ,product_code: '111', min_amount: 3) }

      it 'raises error ' do
        expect { calculator.call}.to raise_error Services::DiscountCalculator::ProductCodeMismatchError
      end      
    end

    context 'when the rule provided matches the product' do
      context 'when the rule has relative discount' do
        let(:rule_params) { super().merge(relative_discount: relative_discount) } 
        let(:relative_discount) { 0.25 }
        it 'applies the discount calculation ' do
          expected_calculation =amount * product.price * (1-relative_discount)
          expect(calculator.call).to eq(expected_calculation)
        end
      end

      context 'when the rule has relative discount and round' do
        let(:rule_params) { super().merge(relative_discount: relative_discount, round: round) }
        let(:relative_discount) { 0.25 }
        context 'when round is floor' do
          let(:round) { :floor }
          it 'applies the discount calculation ' do
            expected_calculation = (amount * (1-relative_discount)).floor * product.price
            expect(calculator.call).to eq(expected_calculation)
          end
        end

        context 'when round is ceil' do
          let(:round) { :ceil }

          it 'applies the discount calculation ' do
            expected_calculation = (amount * (1-relative_discount)).ceil * product.price
            expect(calculator.call).to eq(expected_calculation)
          end
        end
        
      end

      context 'when the rule has absolute discount' do
        let(:rule_params) { super().merge(absolute_discount: absolute_discount) }
        let(:absolute_discount) { 0.15 }

        it 'applies the discount calculation ' do
          expected_calculation = amount * (product.price - absolute_discount)
          expect(calculator.call).to eq(expected_calculation)
        end
      end
    end

    context 'when there is no rule for a given product' do
      let(:rule) { nil }
      it 'returns the calculation product_amount times product_price' do
        expect(calculator.call).to eq(amount * product.price)
      end
    end
  end
end
