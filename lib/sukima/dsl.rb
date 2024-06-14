# frozen_string_literal: true

class Sukima
  class Dsl
    def initialize(value, error_field)
      @value = value
      @error_field = error_field
    end

    def field(name, schema = nil, **, &)
      schema = Sukima.new(**, &) if schema.nil?
      if @value.key?(name)
        result = schema.validate(@value[name])
        @error_field[name] = result unless result.valid?
      elsif schema.constraints[:required]
        @error_field[name] = ErrorField.new(errors: ['is required'])
      end
    end

    def items(schema = nil, **, &)
      schema = Sukima.new(**, &) if schema.nil?
      @value.each_with_index do |item, index|
        result = schema.validate(item)
        @error_field[index] = result unless result.valid?
      end
    end
  end
end
