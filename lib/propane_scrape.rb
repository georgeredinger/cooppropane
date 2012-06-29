require 'nokogiri'
def propane_scrape(page)
   price=Array.new
      doc = Nokogiri::HTML(page)
     # row=doc.xpath("//tr")
			doc.xpath("//html/body/div[@id='container']/div[@id='wrapper']/div[@id='inwrapper']/div[@id='contentwrapper']/div[@id='sidebar2']/div[@id='text-4']/div[@class='textwidget']/table/tr[4]/td[3]").inner_text[1..-1].to_f
#      prices = Hash.new
#      row.each do |r|
#         #if r.text.chomp.strip =~ /gallons/
#         if r.text.chomp.strip =~ /Gals/
#            q,g,pl,po = r.text.chomp.split
#         end
#         #if g == "gallons"
#         if g == "Gals"
#            prices[q] = po
#         end
#      end
#      prices
end

