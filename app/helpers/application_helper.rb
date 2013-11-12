module ApplicationHelper

  def entry_date
    @entry_date ||= begin
                      @page.regions.to_hash.each do |region_name, region|
                        if (since = region.try(:[], 'content').try(:[], 'since'))
                          return since
                        end
                      end
                      nil
                    end
  end

  def render_partial_for_region(region, prefix = nil)
    if region && (region.response_status == 200 || !region.response_status?)
      partial = prefix.blank? ? "regions/#{region.template}" : "regions/#{prefix}_#{region.template}"
      render :partial => partial,
      :locals => { :object => region.content, :response_status => region.response_status }
    else
      render :partial => 'regions/error', :locals => { :region => region }
    end
  end

  def resized_image_url(url, width, height, options = { :crop => '!', :magnify => 'm', :orientation => 'n' })
    return if url.blank?
    if url.match(/\d+\/region\/\d+/)
      return url.gsub(/(\/files\/\d+\/region\/(\d+|\/){8})/) { "#{$1}#{width}-#{height}/" }
    end
    if url.match(/\/files\/\d+\/\d+-\d+\//)
      image_url, image_id, image_width, image_height, image_crop, image_filename = url.match(%r{(.*)/files/(\d+)/(?:(\d+)-(\d+)(\!)?/)?(.*)})[1..-1]
      return "#{image_url}/files/#{image_id}/#{width}-#{height}#{options[:crop]}#{options[:magnify]}#{options[:orientation]}/#{image_filename}"
    end
    url
  end

  def archive_links(parts_array)
    parts_array = parts_array.compact.select { |part| part.content.items }

    return "" if parts_array.empty?
    @events = parts_array.map(&:archive_dates)

    base_path = parts_array.first.content.collection_link

    list_type = parts_array.first.type.underscore.gsub!('_part', '')

    result = '<ul>'

    current_year = params[:parts_params].try(:[], list_type).try(:[], "interval_year")
    current_month = params[:parts_params].try(:[], list_type).try(:[], "interval_month")

    return "" if archive_monthes.size < 2

    monthes_by_year.each do |year, dates|
      result += '<li>'
      result += link_to(year, '#', :class => "year#{current_year == year.to_s ? ' active' : nil}")
      result += '<ul>'
      result += dates.map{ |date| content_tag(:li, link_to(t('date.month_names')[date.month], "#{base_path}/?parts_params[#{list_type}][interval_year]=#{year}&parts_params[#{list_type}][interval_month]=#{date.month}", :class => current_month == date.month.to_s && current_year == year.to_s ? 'active' : nil)) }.join('')
      result += '</ul></li>'
    end

    result += '</ul>'

    result.html_safe
  end

  def archive_monthes
    (early_date..lately_date).select{|m| m.day == 1 }
  end

  def early_date
    @events.map(&:min_date).map(&:to_date).min.strftime('01-%B-%Y').to_date
  end

  def lately_date
    @events.map(&:max_date).map(&:to_date).max
  end

  def monthes_by_year
    archive_monthes.reverse.group_by(&:year)
  end

  def extension(filename)
    return if filename.blank?
    filename.match(/\.(\w+)$/).try(:[], 1).downcase
  end

  def render_navigation(hash)
    return '' if hash.nil? || hash.empty?
    content_tag :ul do
      hash.map do |key, value|
        content_tag :li, :class => value['selected'] ? 'selected' : nil do
          link_to(value['title'], value['path'])+render_navigation(value['children'])
        end
      end.join.html_safe
    end
  end

end
