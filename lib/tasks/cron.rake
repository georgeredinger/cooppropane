#require 'lib/check_prices'
#desc "check propane prices, if there is a new prices, write it to the database
task :cron => :environment do
    puts "Checking Propane Prices..."
#    checkprices
    puts "will be checking prices once I figure out the path thing"
    puts "done."
end
