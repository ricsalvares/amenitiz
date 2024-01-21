# frozen_string_literal: true

require_relative '../../models/rule'
require 'spec_helper'

RSpec.describe Rule do
  describe '.load_rules_from_config_file' do
    subject { described_class.load_rules_from_config_file }

    it 'reads the config file containing the rules' do
      expect(YAML).to receive(:load_file)
        .with('./config/rules.yml')
        .and_call_original
      expect(subject.map(&:product_code)).to match(%w[GR1 SR1 CF1])
    end
  end

  subject(:rule) { described_class.new(params) }

  describe '#apply?' do
    let(:params) do
      {
        round: nil,
        product_code: code,
        min_amount: amount,
        name: 'test rule',
        relative_discount: nil,
        absolute_discount: 1.0
      }
    end

    let(:amount) { 5 }
    let(:code) { 'code1' }
    context 'when matches the requirements to apply' do
      it 'returns true' do
        expect(rule.apply?(code, amount)).to eq(true)
      end
    end

    context 'when at least one requirement does not match' do
      it 'returns false' do
        different_code = 'different_code'
        expect(rule.apply?(different_code, amount)).to eq(false)
      end
    end
  end

  describe '#apply' do
    let(:params) do
      {
        round: :ceil,
        product_code:,
        min_amount: 2,
        name: 'test rule',
        relative_discount:,
        absolute_discount:
      }
    end
    let(:product_code) { 'GR1' }
    let(:absolute_discount) { nil }
    let(:relative_discount) { nil }

    context 'when relative discount exists' do
      let(:relative_discount) { 0.5 }

      it 'calculates the discount properly' do
        product = Product.new(name: 'test', code: product_code, price: 3.11)
        expect_value = 3 * product.price
        expect(subject.apply_discount(product, 5)).to eq(expect_value)
      end
    end

    context 'when there is no product to apply rule' do
      it 'raises error' do
        product = Product.new(name: 'test', code: '111', price: 1.11)
        expect { subject.apply_discount(product, 2) }.to raise_error Rule::ProductCodeMismatchError
      end
    end
  end
end
