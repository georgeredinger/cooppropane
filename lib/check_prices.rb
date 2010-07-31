require 'rubygems'
require 'dm-core'
require 'config/database'
require 'open-uri'
require 'lib/propane_scrape'
require 'sinatra'
require 'models'
require 'time'

def checkprices
    DataMapper.setup(:default, ENV['DATABASE_URL']||"sqlite3://#{Dir.pwd}/development.db")
    page = open("http://www.co-openergy.org/prices.html")
    prices=propane_scrape(page)
    @scrapes= prices["251-500"]
    @price_last = Prices.last.price
    puts "new: #{@scrapes} existing:#{@price_last}"
    if @scrapes.to_f.to_s != @price_last.to_s 
      p = Prices.new
      p.attributes = {
      :scraped_at => Time.parse(date),
      :price =>  price.to_f
      }
      p.save
    end
end

