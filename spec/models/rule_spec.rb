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
end
