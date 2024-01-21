# frozen_string_literal: true

require_relative '../../models/rule'
require 'spec_helper'

RSpec.describe Rule do
  subject { described_class.new }

  describe '.load_rules_from_config_file' do
    subject { described_class.load_rules_from_config_file }

    it 'reads the config file containing the rules' do
      expect(YAML).to receive(:load_file)
        .with('./config/rules.yml')
        .and_call_original
      expect(subject.map(&:product_code)).to match(%w[GR1 SR1 CF1])
    end
  end
end
