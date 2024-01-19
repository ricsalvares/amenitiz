require_relative '../cash_register_runner.rb'

RSpec.describe CashRegisterRunner, :type => :request do
  subject { described_class.new.run }

  describe "run" do
    it { is_expected.to eq "Ran!" }
  end
end