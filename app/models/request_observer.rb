class RequestObserver < ActiveRecord::Observer
  def after_save(request)
    RequestMailer.delay.send_email(request)
  end
end
