require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  # config.active_storage.service = :local  #（必要な場合のみ使用）
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info").to_sym
  config.log_tags = [ :request_id ]
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.log_formatter = ::Logger::Formatter.new

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false

  # SSL強制を有効化
  config.force_ssl = true

  # ホストの設定
  config.hosts << ENV.fetch('ALLOWED_HOSTS', '').split(',')

  # ActionMailerの設定
  # config.action_mailer.default_url_options = { host: 'your-app-domain.herokuapp.com' }
end

# heroku用の環境変数設定
# heroku config:set RAILS_ENV=production
# heroku config:set RAILS_SERVE_STATIC_FILES=true
# heroku config:set RAILS_LOG_TO_STDOUT=true
# heroku config:set ALLOWED_ORIGINS=https://your-frontend-domain.com
# heroku config:set ALLOWED_HOSTS=your-app-domain.herokuapp.com
# heroku config:set RAILS_MASTER_KEY=your-master-key
