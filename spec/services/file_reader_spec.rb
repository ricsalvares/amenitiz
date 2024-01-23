# frozen_string_literal: true

require_relative '../../services/file_reader'
require 'csv'
require 'spec_helper'

RSpec.describe Services::FileReader do
  subject(:fr) { described_class.new(file_name) }
  let(:file_name) { 'file.name' }

  describe '#read' do
    context 'the file exists' do
      it 'returns a csv ignoring the headers' do
        file_content =  "product_list_codes,expected_total\nGR1;GR1,3.11"
        allow(File).to receive(:read).with(file_name).and_return(file_content)
        expect(CSV).to receive(:parse).with(file_content).and_call_original
        expect(fr.read).to eq([['GR1;GR1', '3.11']])
      end
    end

    context 'the file does not exist' do
      it { expect { fr.read }.to raise_error(RuntimeError) }
    end
  end
end
