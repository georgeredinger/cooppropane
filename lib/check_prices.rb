require 'rubygems'
require 'dm-core'
require 'config/database'
require 'open-uri'
require  'lib/propane_scrape'
require 'sinatra'
require 'models'
require 'time'

def checkprices
   DataMapper.setup(:default, ENV['DATABASE_URL']||"sqlite3://#{Dir.pwd}/development.db")
   #page = open("http://www.co-openergy.org/prices.html").read
   page = open("http://www.co-openergy.org/current-prices").read
   prices=propane_scrape(page)
   @scrapes= prices["251-500"]
   price = @scrapes.to_f
   @price_last = Prices.all(:order => [:scraped_at]).last.price
   if price.to_s != @price_last.to_s
      p = Prices.new
      p.attributes = {
         :scraped_at => Time.now,
         :price =>  price.to_f
      }
      p.save
      if defined? Heroku
      #   Moonshado::Sms.configure do |config|
      #      config.api_key = ENV['MOONSHADOSMS_URL']
      #   end
      #   sms = Moonshado::Sms.new("2085973127", "Coop Propane Price Change: #{@price_last} to #{price}")
      #   status=sms.deliver_sms
      end
   end
   if defined? Heroku
      #sms = Moonshado::Sms.new("2085973127", "Coop Propane Price Change: #{@price_last} to #{price}")
      #status=sms.deliver_sms
   end
   puts "#{price},#{@price_last}"
   {:new => price,:old => @price_last}
end
