# frozen_string_literal: true

require_relative '../../services/discount_rule_handler'
require_relative '../../models/store'
require_relative '../../models/product'

require 'yaml'
require 'spec_helper'

RSpec.describe Services::DiscountRuleHandler do
  subject(:discount_handler) { described_class.new(store) }
  let(:store) { Store.new(products:) }
  let(:products) { Product.load_products_from_config_file }

  it { is_expected.to delegate_method(:products).to(:store) }
  it { is_expected.to delegate_method(:rules).to(:store) }

  describe 'initialize' do
    let(:store) { 1 }
    it 'raises error when store is not provided' do
      expect { subject }.to raise_error Services::DiscountRuleHandler::WrongArgumentError
    end
  end

  describe '#apply_discount_for' do
    context 'when there is a rule for a given product' do
      it 'returns the calculation with discount applied' do
        product = products.find { _1.code == 'GR1' }
        expect(discount_handler.apply_discount_for('GR1', 5)).to eq(3 * product.price)
      end
    end

    context 'when there is no rule for a given product' do
      let(:apple) { Product.new(name: 'Apple', code: 'APL1', price: 1.99) }
      let(:products) { [apple] }

      it 'returns the calculation product_amount times product_price' do
        amount = rand(1..10)
        expect(discount_handler.apply_discount_for(apple.code, amount))
          .to eq(amount * apple.price)
      end
    end
  end
end
