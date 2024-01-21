# frozen_string_literal: true

require_relative '../../services/cash_register'
require_relative '../../models/store'
require_relative '../../models/product'
require 'spec_helper'

RSpec.describe CashRegister do
  subject(:cr) { described_class.new(store) }
  let(:store) { Store.new }

  it { is_expected.to delegate_method(:products).to(:store) }
  it { is_expected.to delegate_method(:rules).to(:store) }

  describe 'initialize' do
    let(:store) { 1 }
    it 'raises error when store is not provided' do
      expect { subject }.to raise_error CashRegister::WrongArgumentError
    end
  end

  describe '#scan' do
    context 'when the product is registered in the store' do
      let(:product) { Product.new(code: 'p1', name: 'My product', price: 99.99) }
      let(:store) { Store.new(products: [product]) }
      it 'increments its count by 1' do
        expect { subject.scan(product.code) }.to change { subject.basket[product.code] }
          .from(0)
          .to(1)
      end
    end

    context 'when the product is not registered in the store' do
      it 'raises error while scanning' do
        expect { subject.scan('invalid_code') }.to raise_error CashRegister::InvalidProductError
      end
    end
  end

  describe '#gross_total' do
    context 'when there is product' do
      let(:apple) { Product.new(name: 'Apple', code: 'APL1', price: 1.99) }
      let(:lime) { Product.new(name: 'Lime', code: 'LM1', price: 0.24) }
      let(:store) { Store.new(products: [apple, lime]) }

      before do
        2.times { cr.scan(apple.code) }
        3.times { cr.scan(lime.code) }
      end

      it 'calculates the gross total (without discount)' do
        expected_gross_total = (2 * apple.price) + (3 * lime.price)
        expect(cr.gross_total).to eq(expected_gross_total)
      end
    end
  end
end
