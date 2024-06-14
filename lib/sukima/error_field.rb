# frozen_string_literal: true

class Sukima
  class ErrorField
    attr_accessor :errors

    def initialize(errors: [])
      @children = {}
      @errors = errors
    end

    def [](name)
      @children[name]
    end

    def []=(name, value)
      @children[name] = value
    end

    def valid?
      return false unless @errors.empty?

      @children.each_value { return false unless _1.valid? }
      true
    end

    def messages(path = [])
      prefix = path.empty? ? '' : "#{path.join('.')} "
      result = @errors.map { "#{prefix}#{_1}" }
      @children.each do |name, error_field|
        result.concat(error_field.messages(path + [name]))
      end
      result
    end

    def to_h
      { errors: @errors, children: @children.transform_values(&:to_h) }
    end

    protected

    attr_reader :children
  end
end
