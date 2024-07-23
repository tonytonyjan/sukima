# frozen_string_literal: true

require_relative 'test_helper'
require 'sukima'

class SukimaTest < Minitest::Test
  def test_invalid
    result = Sukima.new(type: String).validate(1)
    refute result.valid?
    assert_equal ['should be String'], result.messages
  end

  def test_valid
    result = Sukima.new(type: String).validate('test')
    assert result.valid?
  end

  def test_nil_is_accepted_by_default
    result = Sukima.new(type: String).validate(nil)
    assert result.valid?
  end

  def test_hash
    sukima = Sukima.new(type: Hash) do
      field :name, type: String, required: true
      field :age, type: Integer
    end
    assert sukima.validate({ name: 'test', age: 1 }).valid?
    assert sukima.validate({ name: 'test' }).valid?

    result = sukima.validate({})
    refute result.valid?
    assert_equal ['name is required'], result.messages
  end

  def test_array_of_string
    sukima = Sukima.new(type: Array) do
      items type: String
    end
    assert sukima.validate(%w[test test2]).valid?
    assert sukima.validate([]).valid?
    result = sukima.validate(['test', 1, 'test2', 1])
    refute result.valid?
    assert_equal ['1 should be String', '3 should be String'], result.messages
  end

  def test_nesting
    sukima = Sukima.new type: Hash do
      field :list, type: Array, required: true do
        items type: Hash do
          field :name, type: String, required: true
          field :age, type: Integer
        end
      end
    end
    assert_equal(
      ['list.0.name is required', 'list.1.age should be Integer'],
      sukima.validate({ list: [{}, { name: 'name', age: '1' }] }).messages
    )
  end

  def test_use_schema_as_field_argument
    sukima = Sukima.new type: Hash do
      field :foo, Sukima.new(type: String)
    end
    assert_equal(
      ['foo should be String'],
      sukima.validate({ foo: 1 }).messages
    )
  end

  def test_extension_for_field
    shared = Sukima.new type: String, required: true
    sukima = Sukima.new type: Hash do
      field :name, shared
    end
    assert sukima.validate({ name: 'test' }).valid?
    refute sukima.validate({}).valid?
  end

  def test_extension_for_items
    shared = Sukima.new type: String, required: true
    sukima = Sukima.new type: Array do
      items shared
    end
    assert sukima.validate(%w[test test2]).valid?
    refute sukima.validate([123, 'test2']).valid?
  end

  def test_branching
    sukima = Sukima.new type: Hash do |hash|
      field :type, type: String

      field :payload, type: Hash do
        case hash[:type]
        when 'website'
          field :url, type: String, required: true
        when 'user'
          field :email, type: String, required: true
        end
      end
    end
    assert sukima.validate({ type: 'website', payload: { url: 'http://example.com' } }).valid?
    refute sukima.validate({ type: 'website', payload: { email: 'user@example.com' } }).valid?
    assert sukima.validate({ type: 'user', payload: { email: 'user@example.com' } }).valid?
    refute sukima.validate({ type: 'user', payload: { url: 'http://example.com' } }).valid?
  end

  def test_custom_constraint
    Sukima::Constraints.define_singleton_method(:url) do |_, value|
      'should match http' unless value.match?(/http/)
    end

    sukima = Sukima.new type: String, url: true
    assert sukima.validate('http://example.com').valid?
    refute sukima.validate('example.com').valid?
  end
end
