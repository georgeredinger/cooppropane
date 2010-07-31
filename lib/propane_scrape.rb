require 'nokogiri'
def propane_scrape(page)
   price=Array.new
      doc = Nokogiri::HTML(page)
      row=doc.xpath("//tr")
      prices = Hash.new
      row.each do |r|
         if r.text.chomp.strip =~ /gallons/
            q,g,p = r.text.chomp.split
         end
         if g == "gallons"
            prices[q] = p
         end
      end
      prices
end

