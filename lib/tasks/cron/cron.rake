require 'lib/check_prices'
desc "check propane prices, if there is a new prices, write it to the database"
task :cron  do
    puts "Checking Propane Prices..."
    checkprices
    puts "done."
end
