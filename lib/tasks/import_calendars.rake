desc 'Import calendars for parsing'
task :import_calendars => :environment do
  yml = (YAML.load_file(Rails.root.join('config', 'calendars.yml'))['calendars'] || {})
end
