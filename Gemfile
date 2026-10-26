source "https://rubygems.org"

# =============================================================================
# SECURITY UPDATE (2026) - see SECURITY_UPDATES.md for the full story.
#
# Rails 5.2.2 and Ruby 2.6 are both end-of-life and had dozens of published
# security holes (remote code execution, XSS, denial of service, SQL issues in
# Rails, Rack, Nokogiri, Loofah, Puma, ...). That's almost certainly what
# GitHub's security alert emails were about.
#
# This Gemfile moves the app to Rails 8.1 on a supported Ruby. Gems that Rails 8
# no longer needs were removed:
#   - sass-rails, uglifier, coffee-rails -> replaced by Propshaft (plain CSS/JS)
#   - turbolinks                         -> unmaintained; not needed here
#   - jbuilder                           -> the app never served JSON
#   - spring, listen                     -> removed from the Rails defaults
#   - byebug                             -> replaced by Ruby's built-in "debug"
#   - chromedriver-helper                -> deprecated; selenium-webdriver
#                                           downloads drivers by itself now
#
# Gemfile.lock was deleted because it pinned all the vulnerable versions.
# Run `bundle install` once to create a fresh one, then commit it.
# Out with the old Gems, in with the new - this blog is back on the rails.
# =============================================================================

ruby ">= 3.2.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.0"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use sqlite3 as the database for Active Record
gem "sqlite3", ">= 2.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 6.4"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  # Run it any time with:  bin/brakeman
  gem "brakeman", require: false

  # Checks Gemfile.lock against the Ruby security advisory database.
  # Run it any time with:  bundle exec bundle-audit check --update
  gem "bundler-audit", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end
