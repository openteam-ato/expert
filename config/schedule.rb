require File.expand_path('../directories.rb', __FILE__)

dir = Directories.new

if RUBY_PLATFORM =~ /freebsd/
  set :job_template, "/usr/local/bin/bash -l -i -c ':job' 1>#{dir.log('schedule.log')} 2>#{dir.log('schedule-errors.log')}"
else
  set :job_template, "/bin/bash -lic ':job'"
end

every :hour do
  rake 'import_calendars', :output => { :error => 'log/error-import-calendars.log', :standard => 'log/cron-import-calendars.log'}
end
