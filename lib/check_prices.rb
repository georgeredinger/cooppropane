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
   #page = open("http://www.co-openergy.org/current-prices").read
   page = open("http://www.co-openergy.org").read
#   prices=propane_scrape(page)
#	 puts "Prices=#{prices}"
#	 return
#   @scrapes= prices["251-500"]
	
   price=propane_scrape(page)

#	 puts "price=#{price}"
	 
   #price = @scrapes.to_f
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
#TODO: only tweet on price change
  Twitter.configure do |config|
		config.consumer_key = ENV['Consumer_key']
		config.consumer_secret = ENV['Consumer_secret']
		config.oauth_token = ENV['Access_token']
		config.oauth_token_secret = ENV['Access_token_secret']
	end
#TODO: why does Twitter.update allways thow an error?
  Twitter.update("#{Time.now.strftime('%m/%d/%Y'}  Price per Gallon changed from $#{@price_last} to $#{price}") rescue Twitter::Error
	
 	{:new => price,:old => @price_last}
end
