require_relative "boot"

#require "rails/all"

# Add the following instead of rails/all:
require "rails"
# Comment out unneeded frameworks
# require "active_record/railtie" rescue LoadError
# require "active_storage/engine" rescue LoadError
require "action_controller/railtie" rescue LoadError
require "action_view/railtie" rescue LoadError
require "action_mailer/railtie" rescue LoadError
require "active_job/railtie" rescue LoadError
require "action_cable/engine" rescue LoadError
# require "action_mailbox/engine" rescue LoadError
# require "action_text/engine" rescue LoadError
require "rails/test_unit/railtie" rescue LoadError


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RoterizeApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])
    
    config.mongoid.logger = Logger.new(STDERR, :warn)
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end
