require 'fileutils'
require 'curb'
require 'progress_bar'
require 'yaml'

desc 'Import calendars for parsing'
task :import_calendars => :environment do
  target_dir = Rails.root.join('tmp', 'calendars')
  FileUtils.mkdir target_dir unless File.directory?(target_dir)
  councils = (YAML.load_file(Rails.root.join('config', 'calendars.yml'))['calendars'] || {})
  bar = ProgressBar.new(councils.count)
  begin
    councils.each do |council|
      council_slug = council.first
      calendar_url = council.second['url']
      File.open("#{target_dir}/#{council_slug}.ics", 'wb') do |saved_file|
        http = Curl.get(calendar_url)
        saved_file.write(http.body_str)
      end
      bar.increment!
    end
  rescue => e
    raise e
  end
end
