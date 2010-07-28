$:.unshift File.join(File.dirname(__FILE__),'..','lib')
require 'test/unit'
require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'find'
class ScrapeTest < Test::Unit::TestCase
  def test_scrape
    Find.find('./test/') do |f| 
      price=Array.new
      if f =~ /^.*\.html/
        (2..7).each do |quantity|
          path="/html/body/div[@class='Section1']/table[3][@class='MsoNormalTable']/tbody/tr/td[2]/table[@class='MsoNormalTable']/tbody/tr/td/div/table[@class='MsoNormalTable']/tbody/tr[1]/td/table[@class='MsoNormalTable']/tbody/tr/td[2]/div/table[@class='MsoNormalTable']/tbody/tr[#{quantity}]/td[3]/p[@class='MsoNormal']/span"
          doc = Nokogiri::HTML(open(f))
          price << doc.xpath(path).text
        end
      assert  price[1].to_f > 0.0
      assert  price[2].to_f > 0.0
      assert  price[3].to_f > 0.0
      assert  price[4].to_f > 0.0
      assert  price[5] == "Call"


      end
          end
  end
end

