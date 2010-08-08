#!/usr/bin/ruby
#
require 'rubygems'
require 'time'
require 'propane_scrape'
def make_seed
  DataMapper.setup(:default, ENV['DATABASE_URL']||"sqlite3://#{Dir.pwd}/development.db")
  DataMapper.auto_migrate!
  
  filename="#{Dir.pwd}/lib/test_seed.txt"
  file = File.new(filename, 'r')
  
  file.each_line("\n") do |row|
    date,price = row.split(",")
   # puts "#{date},#{price}"
    p = Prices.new
    p.attributes = {
           :scraped_at => Time.parse(date),
           :price =>  price.to_f
    }
    p.save
  end

  prices = Prices.all
  prices.each do |p|
    puts "#{p.scraped_at},#{p.price}"
  end
end
#
Dir.glob("*.html") do |file_name|
  basename,extention=file_name.split(".")
  year,month,day = basename.split("_")
  time_archived = Time.parse("#{month}/#{day}/#{year}")
  month_number = time_archived.month 
  price1 = propane_scrape(open(file_name).read)["201-400"] #price breakpoint changed in 2006
  price2= propane_scrape(open(file_name).read)["251-500"]
  price = price1||price2
  puts "#{year}-#{month_number}-#{day},#{price}"
end 
