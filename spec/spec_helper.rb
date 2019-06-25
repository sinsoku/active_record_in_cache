# frozen_string_literal: true

require 'bundler/setup'
require 'active_record_in_cache'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  require 'active_support/testing/time_helpers'
  config.include ActiveSupport::Testing::TimeHelpers
end

require 'rails'
require 'active_record/railtie'
require 'active_support/core_ext/numeric/bytes'

# app
class TestApp < Rails::Application
  config.eager_load = false
  config.active_support.deprecation = :log
  config.root = __dir__
  config.cache_store = :memory_store, { size: 64.megabytes }
end
Rails.application.initialize!

class ApplicationRecord < ActiveRecord::Base
  include ActiveRecordInCache::Methods

  self.abstract_class = true
end

class Article < ApplicationRecord
  scope :published, -> { where.not(published_at: nil) }
end

class Comment < ApplicationRecord
  belongs_to :article
end

class CreateTables < ActiveRecord::Migration[5.0]
  def self.up
    create_table(:articles) do |t|
      t.datetime :published_at
      t.timestamps
    end

    create_table(:comments) do |t|
      t.references :article
      t.string :body
      t.timestamps
    end
  end
end
CreateTables.up
