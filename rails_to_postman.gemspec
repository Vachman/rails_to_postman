# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rails_to_postman/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Gevorgyan Vachagan"]
  gem.email         = ["va4@me.com"]
  gem.description   = %q{Export rails routes to json for Postman REST Client}
  gem.summary       = %q{Convert Ruby on Rails application routes to Postman REST Client format end export to json file.}
  gem.homepage      = "https://github.com/Vachman/rails_to_postman"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rails_to_postman"
  gem.require_paths = ["lib"]
  gem.version       = RailsToPostman::VERSION 
end
