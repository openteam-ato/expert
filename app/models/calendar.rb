# encoding: utf-8

class Calendar < ActiveRecord::Base

  #return calendars from ics files
  def self.calendars
    input_dir = Rails.root.join('tmp', 'calendars')
    councils = (YAML.load_file(Rails.root.join('config', 'calendars.yml'))['calendars'] || {})
    calendars = []
    councils.map(&:first).each do |slug|
      icsfile = Rails.root.join('tmp/calendars', "#{slug}.ics")
      calendars.push Icalendar.parse(File.open(icsfile))
    end
    calendars
  end

  #return calendar by url
  def self.calendar()

  end

  #return events from all calendars in ics
  def self.events
    events = []
    calendars.each do |c|
      events << c.first.events
    end
    events.flatten.compact.sort{ |a, b| b.dtstart <=> a.dtstart }
  end

end
