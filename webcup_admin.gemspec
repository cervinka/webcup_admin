# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'webcup_admin/version'

Gem::Specification.new do |spec|
  spec.name          = 'webcup_admin'
  spec.version       = WebcupAdmin::VERSION
  spec.authors       = ['Petr Cervinka']
  spec.email         = ['petr@petrcervinka.cz']

  spec.summary       = %q{Ruby gem for rapid admin building.}
  # spec.description   = %q{Write a longer description or delete this line.}
  spec.homepage      = 'https://github.com/cervinka/webcup_admin'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.add_dependency 'rails', '>= 4.0'
  spec.add_dependency 'rspec-rails'

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
end
