# frozen_string_literal: true

require_relative '../../models/store'
require_relative '../../models/product'
require 'spec_helper'
RSpec.describe Store do
  subject { described_class.new(**params) }
  let(:params) { {} }

  describe 'initialize' do
    context 'when invalid params are provided' do
      let(:params) { { products: [1] } }

      it { expect { subject }.to raise_error(Store::WrongArgumentError) }
    end
  end

  context '#products' do
    it { expect(subject.products).to eq({}) }
  end

  context '#rules' do
    let(:params) { super().merge(rules:) }
    let(:rules) { [1, 2, 3] } # So far any collection is enough; To be changed

    it { expect(subject.rules).to eq rules }
  end

  describe '#register_product' do
    context 'successfully registers a product' do
      it do
        product = Product.new(name: 'product1', price: 3.22, code: 'p1')
        expect { subject.register_product(product) }
          .to change { subject.products[product.code] }
          .from(nil)
          .to(product)
      end

      context 'context when a product already exists' do
        let(:params) { super().merge(products:) }
        let(:products) { [product1] }
        let(:product1) { Product.new(name: 'product1', price: 3.22, code: 'p1') }

        it 'is overriden' do
          product2 = Product.new(name: 'New Product', price: 0.99, code: product1.code)
          expect do
            subject.register_product(product2)
          end.to change { subject.products[product1.code] }
             .from(product1)
            .to(product2)
        end
      end
    end

    context 'when the provided argument is invalid' do
      it 'raises an error' do
        invalid_product = {} # anything but a Product
        expect { subject.register_product(invalid_product) }.to raise_error Store::InvalidProductError
      end
    end
  end
end
