# if Rails.env == 'production'
#   ENV["REDIS_URL"] ||= "redis://profiles.transi.st:6379"
# 
#   Sidekiq.configure_client do |config|
#     config.redis = { :url => ENV["REDIS_URL"], :namespace => 'profiles' }
#   end
# end