require 'nokogiri'
def propane_scrape(page)
   price=Array.new
      doc = Nokogiri::HTML(page)
      row=doc.xpath("//tr")
      prices = Hash.new
      row.each do |r|
         #if r.text.chomp.strip =~ /gallons/
         if r.text.chomp.strip =~ /Gals/
            q,g,pl,po = r.text.chomp.split
         end
         #if g == "gallons"
         if g == "Gals"
            prices[q] = po
         end
      end
      prices
end

