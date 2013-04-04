require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "rails/test_unit/railtie"
require "sprockets/railtie"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Profiles
  class Application < Rails::Application
    
    Mongoid.logger.level = Logger::DEBUG
    Moped.logger.level = Logger::DEBUG
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    config.generators do |g| 
      g.orm :mongoid 
    end

    config.assets.initialize_on_precompile = false 
    config.assets.enabled = true
    config.assets.version = '1.0'
  end
end
