Discourse::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = true

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # stuff should be pre-compiled
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  config.cache_store = :dalli_store, ENV["MEMCACHIER_SERVERS"].try(:split, ","),
                    {:username => ENV["MEMCACHIER_USERNAME"],
                     :password => ENV["MEMCACHIER_PASSWORD"]}

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :port =>           ENV['SMTP_PORT'],
    :address =>        ENV['SMTP_SERVER'],
    :user_name =>      ENV['MANDRILL_USERNAME'],
    :password =>       ENV['MANDRILL_APIKEY'],
    :domain =>         'heroku.com',
    :authentication => :plain
  }
  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # I dunno ... perhaps the built-in minifier is using closure
  #   regardless it is blowing up
  config.ember.variant = :development
  config.ember.ember_location = "#{Rails.root}/app/assets/javascripts/external_production/ember.js"
  config.ember.handlebars_location = "#{Rails.root}/app/assets/javascripts/external/handlebars-1.0.rc.3.js"
  config.handlebars.precompile = true

  config.assets.initialize_on_precompile = false
end
