# frozen_string_literal: true

require_relative '../../services/cash_register_runner'

RSpec.describe Services::CashRegisterRunner do
  subject { described_class.new(input_reader) }
  let(:input_reader) { double(read: input) }
  let(:input) { [[product_code, total]] }

  describe '#run' do
    let(:product_code) { 'CF1' }
    let(:total) { '11.23' }

    it do
      allow(input_reader).to receive(:read).and_return(input)
      expect_any_instance_of(Services::CashRegister).to receive(:scan).once.with(product_code).and_call_original
      expect_any_instance_of(Services::CashRegister).to receive(:total).and_call_original
      expect(Product).to receive(:load_products_from_config_file).and_call_original

      output_message = "\"products: #{product_code} | €#{total}  (expected €#{total})\"\n"
      expect { subject.run }.to output(output_message).to_stdout
    end
  end
end
