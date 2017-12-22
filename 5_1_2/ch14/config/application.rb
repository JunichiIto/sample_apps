# require_relative(2.12.9)
require_relative 'boot'

# require(2.12.7)
require 'rails/all'

# 引数のsplat展開(4.7.6)
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# モジュールを名前空間として使う(8.6.1)
module SampleApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
