require 'lib/check_prices'
task :cron => :environment do
  puts "Checking Propane Prices..."
  checkprices
  puts "done."
  end
end
