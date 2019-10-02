ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'fileutils'
require 'factory_bot'
require 'database_cleaner'

module AroundEachTest
  def before_setup
    super
    DatabaseCleaner.clean
    DatabaseCleaner.start
  end
end

class ActiveSupport::TestCase
  include Rails.application.routes.url_helpers
  include FactoryBot::Syntax::Methods
  include AroundEachTest
  FactoryBot.find_definitions

  # Carrierwave setup and teardown
  carrierwave_root = Rails.root.join('test', 'support', 'carrierwave')

  CarrierWave.configure do |config|
    config.root = carrierwave_root
    config.enable_processing = false
    config.storage = :file
    config.cache_dir = Rails.root.join('test', 'support', 'carrierwave', 'carrierwave_cache')
  end


  teardown do
    Dir.glob(carrierwave_root.join('*')).each do |dir|
      FileUtils.remove_entry(dir, true)
    end
  end
end
