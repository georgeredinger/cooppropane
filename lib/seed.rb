require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'models'
require 'time'
#gem 'dm-sqlite-adapter', '~> 1.0.0' 
require  'dm-migrations'
def seed
  DataMapper.setup(:default, ENV['DATABASE_URL']||"sqlite3://#{Dir.pwd}/development.db")
  DataMapper.auto_migrate!
  
  filename="#{Dir.pwd}/lib/seed.txt"
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
