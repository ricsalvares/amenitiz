# frozen_string_literal: true

require_relative '../../models/product'
require 'spec_helper'

RSpec.describe Product do
  subject { described_class.new(**params) }
  let(:params) { { name:, price:, code: } }
  let(:name) { 'product name' }
  let(:price) { 3.99 }
  let(:code) { 'PN1' }

  describe '.load_products_from_config_file' do
    subject { described_class.load_products_from_config_file }

    it 'reads the config file containing the products attributes' do
      expect(YAML).to receive(:load_file)
        .with('./config/products.yml')
        .and_call_original
      expect(subject.map(&:code)).to match(%w[GR1 SR1 CF1])
    end
  end

  describe 'initialize' do
    context 'when invalid params are provided' do
      shared_examples 'product with invalid params' do |att|
        let(:params) { super().merge(att.to_sym => nil) }

        it { expect { subject }.to raise_error(Product::WrongArgumentError) }
      end

      it_behaves_like 'product with invalid params', :name
      it_behaves_like 'product with invalid params', :price
      it_behaves_like 'product with invalid params', :code
    end
  end

  describe '#name' do
    it { expect(subject.name).to eq name }
  end

  describe '#code' do
    it { expect(subject.code).to eq code }
  end

  describe '#price' do
    it { expect(subject.price).to eq price }
  end
end
