Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV['ALLOWED_ORIGINS'].to_s.split(',').map(&:strip)
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: ActiveModel::Type::Boolean.new.cast(ENV['CORS_CREDENTIALS'])
  end
end
