ActionMailer::Base.smtp_settings = {
  :address => Settings['mail']['address'],
  :port    => Settings['mail']['port'],
  :domain  => Settings['mail']['domain']
}

%w[authentication enable_starttls_auto user_name password].each do |item|
  if Settings.try(:[], 'mail').try(:[], item).present?
    ActionMailer::Base.smtp_settings.merge!({ item.to_sym => Settings['mail'][item] })
  end
end
