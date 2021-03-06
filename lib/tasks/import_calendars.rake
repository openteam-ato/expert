require 'fileutils'
require 'curb'
require 'progress_bar'
require 'yaml'

desc 'Import calendars for parsing'
task :import_calendars => :environment do
  target_dir = Rails.root.join('tmp', 'calendars')
  FileUtils.mkdir target_dir unless File.directory?(target_dir)
  councils = (YAML.load_file(Rails.root.join('config', 'calendars.yml'))['calendars'] || {})
  bar = ProgressBar.new(councils.count * 2)
  begin
    councils.each do |council|
      council_slug = council.first
      calendar_url = council.second['url']
      File.open("#{target_dir}/#{council_slug}.ics", 'wb') do |saved_file|
        curl = Curl::Easy.new(calendar_url)
        curl.ssl_verify_peer = false
        curl.perform
        saved_file.write(curl.body_str)
      end
      bar.increment!
      calendar_url = council.second['url'].gsub(/\/ical\//, '/feeds/').gsub(/\.ics$/, '')
      File.open("#{target_dir}/#{council_slug}.xml", 'wb') do |saved_file|
        curl = Curl::Easy.new(calendar_url)
        curl.ssl_verify_peer = false
        curl.perform
        saved_file.write(curl.body_str)
      end
      bar.increment!
    end
  rescue => e
    raise e
  end
end
