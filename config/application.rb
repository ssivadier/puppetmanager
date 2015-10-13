require File.expand_path('../boot', __FILE__)

require 'rails/all'

I18n.available_locales = [:en, :fr]
I18n.enforce_available_locales = true

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module PuppetManager
  class Application < Rails::Application
	config.assets.initialize_on_precompile = false
        config.time_zone = 'Paris' # set default time zone to "Paris"
        config.i18n.default_locale = :fr # set default locale to French
  end
end
