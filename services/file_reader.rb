# frozen_string_literal: true

require 'csv'
module Services
  # Class to read a CSV file
  class FileReader
    def initialize(file_name)
      @file_name = file_name
    end

    def read
      CSV.parse(file_content)[1..]
    rescue Errno::ENOENT => e
      raise "Error while reading file: #{e}"
    end

    private

    attr_reader :file_name

    def file_content
      @file_content = File.read(file_name)
    end
  end
end
