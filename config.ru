# This file is used by Rack-based servers to start the application.

require_relative "config/environment"
# Allow font files to be loaded from anywhere (for loading webfonts in Firefox)
require 'rack/cors'
  use Rack::Cors do
    allow do
      origins '*'
      resource '*', 
          headers: :any, 
          methods: [:get, :post, :delete, :put, :options]
      
    end
  end
run Rails.application
Rails.application.load_server
