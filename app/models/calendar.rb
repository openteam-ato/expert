# encoding: utf-8

class Calendar < ActiveRecord::Base

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

  def self.calendar_events(name)
    icsfile = Rails.root.join('tmp/calendars', "#{name}.ics")
    begin
      calendar = Icalendar.parse(File.open(icsfile))
    rescue => e
    end
    return [] if calendar.blank? || calendar.empty?
    calendar.first.events.compact.sort{ |a, b| b.dtstart <=> a.dtstart }
  end

  #return events from all calendars in ics
  def self.events
    events = []
    calendars.each do |c|
      events << c.first.try(:events)
    end
    events.flatten.compact.sort{ |a, b| b.dtstart <=> a.dtstart }
  end

end
