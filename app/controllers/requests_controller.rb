#encoding: utf-8

class RequestsController < MainController
  def new
    @request = Request.new(params[:request])

    super
  end

  def create
    super

    @request = Request.new(params[:request])

    if verify_recaptcha(:model => @request) && @request.save
      redirect_to new_request_path, :notice => 'Сообщение отправлено успешно, спасибо за обращение.'
    else
      @request.valid?

      render :new
    end
  end
end
