# frozen_string_literal: true

require_relative '../../services/cash_register'
require_relative '../../models/store'

require 'spec_helper'

RSpec.describe CashRegister do
  subject { described_class.new(store) }
  let(:store) { Store.new }

  describe '#scan' do
    pending 'scan'
  end

  describe '#total' do
    pending 'calculate total'
  end
end
