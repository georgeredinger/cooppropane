require 'config/database'
require 'dm-core'
require 'dm-migrations'
require 'haml'
require 'lib/check_prices'
require 'lib/makeplot'
require 'lib/propane_scrape'
require 'logger'
require 'models'
require 'open-uri'
require 'rubygems'
require 'sass'
require 'sinatra'
require 'sinatra/base'
require 'time'
require 'twitter'

def checkprices
	DataMapper.setup(:default, ENV['DATABASE_URL']||"sqlite3://#{Dir.pwd}/development.db")
	page = open("http://www.co-openergy.org").read
	price=propane_scrape(page)
	@price_last = Prices.all(:order => [:scraped_at]).last.price
	if price.to_s != @price_last.to_s
		p = Prices.new
		p.attributes = {
			:scraped_at => Time.now,
			:price =>  price.to_f
		}
		p.save
		puts "#{price},#{@price_last}"
		#TODO: only tweet on price change
		Twitter.configure do |config|
			config.consumer_key = ENV['Consumer_key']
			config.consumer_secret = ENV['Consumer_secret']
			config.oauth_token = ENV['Access_token']
			config.oauth_token_secret = ENV['Access_token_secret']
		end
		#TODO: why does Twitter.update allways thow an error?
		Twitter.update("#{Time.now.strftime('%m/%d/%Y')}  Price per Gallon changed from $#{sprintf("%2.2f",@price_last)} to $#{sprintf("%2.2f",price)}") rescue Twitter::Error

	end
	{:new => price,:old => @price_last}
end

