Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cas, :host => 'myCASURL',
                 :login_url => '/cas/login',
                 :logout_url => '/cas/logout',
                 :service_validate_url => '/cas/serviceValidate',
                 :disable_ssl_verification => true
end
