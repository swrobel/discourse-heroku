require 'airbrake'
if ENV['AIRBRAKE_API_KEY']
  Airbrake.configure do |config|
    config.api_key = ENV['AIRBRAKE_API_KEY']
  end
end