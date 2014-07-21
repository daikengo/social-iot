# Load the rails application
require File.expand_path('../application', __FILE__)

Siot::Application.configure do
	config.action_controller.perform_caching = true
	config.cache_store = :file_store, "#{Rails.root}/tmp/cache"
  	config.action_mailer.default_url_options = { :host => 'server' }
	config.action_mailer.delivery_method = :smtp
	config.action_mailer.smtp_settings = {
    		:tls => true,
    		:openssl_verify_mode => OpenSSL::SSL::VERIFY_NONE,
		    :address => 'smtp.server',
		    :port => 465,
    		:authentication => :login,
		    :domain => 'server',
		    :user_name => 'user',
		    :password => 'password',
        :enable_starttls_auto => false
	}
end

# Initialize the rails application
Siot::Application.initialize!
