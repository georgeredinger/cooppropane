$:.unshift File.join(File.dirname(__FILE__),'..','lib')
require 'test/unit'
require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'find'
require 'propane_scrape.rb'
class ScrapeTest < Test::Unit::TestCase
   def test_scrape_local
      Find.find('./test/') do |f|
         if f =~ /^.*\.html/
           prices=propane_scrape(open(f).read)
           puts prices.inspect 
         end
      end
   end
  def test_scrape_url
    page = open("http://www.co-openergy.org/prices.html")
    prices=propane_scrape(page)
    puts prices.inspect 
  end
end
