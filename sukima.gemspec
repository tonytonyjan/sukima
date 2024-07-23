# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name        = 'sukima'
  spec.version     = '1.0.0'
  spec.summary     = 'Lightweight data schema validation library for Ruby.'
  spec.description = 'Sukima is a lightweight data schema validation library for Ruby ' \
                     'written in only ~100 lines of code. ' \
                     'It provides a simple and flexible way to define constraints for data and validate it.'
  spec.authors     = ['Weihang Jian']
  spec.email       = 'tonytonyjan@gmail.com'
  spec.homepage    = 'https://github.com/tonytonyjan/sukima'
  spec.licenses    = ['MIT']
  spec.files       = Dir['lib/**/*.rb']
  spec.required_ruby_version = '~> 3.3'
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.add_development_dependency 'bundler', '~> 2.5'
  spec.add_development_dependency 'minitest', '~> 5.24'
  spec.add_development_dependency 'rake', '~> 13.2'
  spec.add_development_dependency 'rubocop', '~> 1.64'
end
