class MainController < ApplicationController
  helper_method :cms_address

  def index
    render :file => "#{Rails.root}/public/404", :formats => [:html], :layout => false and return if request_status == 404

    page_regions.each do |region|
      eval "@#{region} = page.regions.#{region}"
    end

    @page_title = page.title

    render "templates/#{page.template}"
  end

  private
    def cms_address
      "#{Settings['cms.url']}/nodes/#{Settings['cms.site_slug']}"
    end

    def remote_url
      request_path, parts_params = request.fullpath.split('?')

      # TODO: выяснить нужно ли энкодить
      #parts_params = URI.encode(parts_params || '')

      "#{cms_address}#{request_path.split('/').compact.join('/')}.json?#{parts_params}"
    end

    def page
      @page ||= Hashie::Mash.new(request_json).page
    end

    def curl_request
      @curl_request ||= Curl::Easy.perform(remote_url) do |curl|
        curl.headers['Accept'] = 'application/json'
      end
    end

    def request_status
      @request_status ||= curl_request.response_code
    end

    def request_body
      @request_body ||= curl_request.body_str
    end

    def is_json?(str)
      begin
        !!JSON.parse(str)
      rescue
        false
      end
    end

    def request_json
      @request_json ||= begin
                          raise ActionController::RoutingError.new('Not Found') unless is_json?(request_body)
                          ActiveSupport::JSON.decode(request_body)
                        end
    end

    def page_regions
      @page_regions ||= page.regions.keys
    end
end
