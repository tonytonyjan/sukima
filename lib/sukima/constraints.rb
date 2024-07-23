# frozen_string_literal: true

class Sukima
  module Constraints
    class << self
      def type(type, value)
        "should be #{type}" unless value.is_a?(type)
      end

      def in(range, value)
        "should be in #{range}" unless range.include?(value)
      end

      def format(pattern, value)
        "should match #{pattern.source}" unless value.is_a?(String) && pattern.match?(value)
      end

      def length(args, value)
        case args
        when Integer
          "should have length of #{args}" unless value.respond_to?(:length) && value.length == args
        when Range
          "should have length in #{args}" unless value.respond_to?(:length) && args.include?(value.length)
        end
      end

      def nonnil(_, value)
        'should not be nil' if value.nil?
      end
    end
  end
end
