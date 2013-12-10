Recaptcha.configure do |config|
  config.public_key  = Settings['recaptcha']['public']
  config.private_key = Settings['recaptcha']['private']
end
