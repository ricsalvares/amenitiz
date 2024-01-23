# frozen_string_literal: true

require_relative '../../services/default_input_reader'
require 'csv'
require 'spec_helper'
require 'stringio'

RSpec.describe Services::DefaultInputReader do
  subject { described_class.new }
  describe '#read' do
    it 'puts the usage guideline' do
      expected_message = [
        'Type products code separate by semicolon (;)',
        'example: CODE1;CODE2',
        'Type expected total amount: '
      ].join("\n")
      input = StringIO.new('CF1')
      $stdin = input
      # TODO: test/mock STDIN gets call
      expect { subject.read }.to output(expected_message).to_stdout
      $stdin = STDIN
    end
  end
end
