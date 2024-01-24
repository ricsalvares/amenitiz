#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'
require 'yaml'
require_relative 'services/file_reader'
require_relative 'services/default_input_reader'
require_relative 'services/cash_register_runner'

FILE_COMMAND = '--file'

def input_source
  return Services::DefaultInputReader.new unless ARGV.count == 2

  command, file_name = *ARGV
  return Services::FileReader.new(file_name) if command == FILE_COMMAND

  "Please run './cash_register_runner.rb --file [path/to/csv/file]'"
end

input = input_source
if input.is_a?(String)
  puts input
else
  Services::CashRegisterRunner.new(input).run
end
