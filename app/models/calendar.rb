# encoding: utf-8

class Calendar

  def self.data_from_google(code)
    http = Curl.get("https://docs.google.com/file/d/#{code}/gviewfetch")
    body = http.body_str
    body = body.slice(5, body.size)

    begin
      body = JSON.parse(body)
      body.try(:[], 'fileData')
    rescue => e
    end
  end

  def self.filename(code)
    data_from_google(code).try(:[], 'filename')
  end

  def self.filename_by_path(path)
    filename(code_from_url(URI.decode(path)))
  end

  def self.mime_type(code)
    begin
      data_from_google(code).try(:[], 'mimeType').split('/').last
    rescue => e
    end
  end

  def self.mime_type_by_path(path)
    mime_type(code_from_url(URI.decode(path)))
  end

  def self.code_from_url(url)
    url.split('/')[5]
  end

  #return calendars from ics files
  def self.calendars
    councils = (YAML.load_file(Rails.root.join('config', 'calendars.yml'))['calendars'] || {})
    calendars = []
    councils.map(&:first).each do |slug|
      icsfile = Rails.root.join('tmp/calendars', "#{slug}.ics")
      begin
        calendars.push Icalendar.parse(File.open(icsfile))
      rescue => e
      end
    end
    calendars.compact
  end

  def self.calendar(name)
    icsfile = Rails.root.join('tmp/calendars', "#{name}.ics")
    begin
      calendar = Icalendar.parse(File.open(icsfile))
    rescue => e
    end
    return [] if calendar.blank? || calendar.empty?
    calendar.first
  end

  def self.calendar_with_links(name)
    ics_calendar = calendar(name)
    xmlfile = Rails.root.join('tmp/calendars', "#{name}.xml")
    f = File.open(xmlfile)
    values = []
    flag = true

    Nokogiri::XML(f).css("entry link").each do |a|
      if flag
        values.push a.attribute('href').value
        flag = false
      else
        flag = true
      end
    end

    ics_calendar = [ics_calendar.try(:events), values]
    f.close

    return [] if ics_calendar.blank? || ics_calendar.empty?

    events = []
    ics_calendar.first.each_with_index do |e, i|
      e.add_resource ics_calendar.second[i] if ics_calendar.second[i].present?
      events << e
    end

    events.flatten.compact.sort{ |a, b| b.dtstart <=> a.dtstart }
  end

  #return events from all calendars in ics
  def self.events
    events = []
    calendars_with_event_links.each do |c|
      c.first.try(:events).each_with_index do |e, i|
        e.add_resource c.second[i] if c.second[i].present?
        events << e
      end
    end
    events.flatten.compact.sort{ |a, b| b.dtstart <=> a.dtstart }
  end

  def self.calendars_with_event_links
    councils = (YAML.load_file(Rails.root.join('config', 'calendars.yml'))['calendars'] || {})
    ics_calendars = calendars
    calendars = []

    councils.map(&:first).each_with_index do |slug, index|
      xmlfile = Rails.root.join('tmp/calendars', "#{slug}.xml")
      begin
        f = File.open(xmlfile)
        values = []
        flag = true
        Nokogiri::XML(f).css("entry link").each do |a|
          if flag
           values.push a.attribute('href').value
           flag = false
          else
            flag = true
          end
        end
        ics_calendars[index].push values
        f.close
      rescue => e
      end
    end

    ics_calendars
  end

  def self.new_events(events)
    new_event = []
    events.each do |e|
      if e.dtstart > Time.now
        new_event.push e
      end
    end

    new_event.sort{ |a, b| b.dtstart <=> a.dtstart }
  end

  def self.calendar_url(name)
    begin
      councils = (YAML.load_file(Rails.root.join('config', 'calendars.yml'))['calendars'] || {})
      return "https://www.google.com/calendar/embed?src=#{councils[name]["url"].split('/')[5]}"
    rescue => e
      return nil
    end
  end

end
