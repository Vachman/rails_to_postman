require "rails_to_postman/version"
require "rails_to_postman/main"
require 'erb'


module RailsToPostman
  require 'rails_to_postman/railtie' if defined?(Rails)
end
