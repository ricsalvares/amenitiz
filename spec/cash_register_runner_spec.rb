# frozen_string_literal: true

require_relative '../cash_register_runner'

RSpec.describe CashRegisterRunner do
  subject { described_class.new }

  describe 'run' do
    it { expect(subject.run).to eq 'Ran!' }
  end

  describe 'init_store' do
    pending 'instantiates a cash register with its dependent object'
  end
end
