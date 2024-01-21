# frozen_string_literal: true

# Product class
# - price(Float): product's price
# - code(String): product's code
# - name(String): product's name
class Product
  class WrongArgumentError < StandardError; end
  class << self
    def load_products_from_config_file
      product_attributes = YAML.load_file('./config/products.yml')
      product_attributes.map do |_, attributes|
        Product.new(**attributes.transform_keys(&:to_sym))
      end
    end
  end

  def initialize(name:, code:, price:)
    raise WrongArgumentError, "name can't be blank/nil" if name.nil? || name.empty?
    raise WrongArgumentError, "price can't be nil" unless price
    raise WrongArgumentError, "code can't be blank/nil" if code.nil? || code.empty?

    @name = name
    @code = code
    @price = price
  end

  attr_reader :name, :code, :price
end
