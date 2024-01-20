# frozen_string_literal: true

require_relative '../cash_register_runner'

RSpec.describe CashRegisterRunner do
  subject { described_class.new.run }

  describe 'run' do
    it { is_expected.to eq 'Ran!' }
  end
end
