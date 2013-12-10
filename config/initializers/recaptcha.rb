Recaptcha.configure do |config|
  config.public_key  = Settings['recaptcha']['public']
  config.private_key = Settings['recaptcha']['private']
  config.proxy       = 'http://www.google.com/recaptcha/api/verify'
end
