require_relative "boot"

# SECURITY UPDATE (2026): instead of `require "rails/all"`, only the parts of
# Rails this blog actually uses are loaded. Action Cable (websockets), Active
# Storage (file uploads), Action Mailbox and Action Text were never used, so not
# loading them shrinks what an attacker could poke at.
require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Blog
  class Application < Rails::Application
    # Initialize configuration defaults for the current Rails version
    # (was 5.2 - bumped to pick up years of safer defaults).
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    config.autoload_lib(ignore: %w[assets tasks])

    # Settings in config/environments/* take precedence over those specified here.
  end
end
