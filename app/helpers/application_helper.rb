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

end
