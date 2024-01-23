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

puts 'running'
# input_source
puts Services::CashRegisterRunner.new(input_source).run
