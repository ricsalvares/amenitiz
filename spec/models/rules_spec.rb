# frozen_string_literal: true

require_relative '../../models/rules'
require 'spec_helper'

RSpec.describe Rules do
  subject { described_class.new }

  describe 'initialize' do
    it 'reads the config file containing the rules' do
      expect(YAML).to receive(:load_file)
        .with('./config/rules.yml')
        .and_call_original
      subject
    end
  end
end
