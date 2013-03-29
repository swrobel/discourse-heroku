require 'autoscaler/sidekiq'
require 'autoscaler/heroku_scaler'

sidekiq_redis = { url: $redis.url, namespace: 'sidekiq', size: 3 }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_redis
  config.server_middleware do |chain|
    chain.add(Autoscaler::Sidekiq::Server, Autoscaler::HerokuScaler.new, 60)
  end
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_redis
  config.client_middleware do |chain|
    chain.add Autoscaler::Sidekiq::Client, 'default' => Autoscaler::HerokuScaler.new
  end
end
