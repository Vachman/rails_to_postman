require 'rails_to_postman'
require 'rails'
module RailsToPostman
  class Railtie < Rails::Railtie
    railtie_name :rails_to_postman

    rake_tasks do
      load "tasks/rails_to_postman.rake"
    end
  end
end