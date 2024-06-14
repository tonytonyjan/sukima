# frozen_string_literal: true

require 'sukima/constraints'
require 'sukima/dsl'
require 'sukima/error_field'

class Sukima
  attr_reader :constraints, :block

  def initialize(**constraints, &block)
    @constraints = constraints
    @block = block
  end

  def validate(value)
    error_field = ErrorField.new
    @constraints.each do |key, args|
      next if key == :required

      message = Constraints.send(key, args, value)
      error_field.errors << message if message
    end

    Dsl.new(value, error_field).instance_exec(value, &@block) if @block && value.is_a?(@constraints[:type])
    error_field
  end
end
