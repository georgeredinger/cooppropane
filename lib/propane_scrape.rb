require 'nokogiri'
def propane_scrape(page)
   price=Array.new
      doc = Nokogiri::HTML(page)
     # row=doc.xpath("//tr")
 # doc.xpath("//html/body/div[@id='container']/div[@id='wrapper']/div[@id='inwrapper']/div[@id='contentwrapper']/div[@id='sidebar2']/div[@id='text-4']/div[@class='textwidget']/table/tr[4]/td[3]").inner_text[1..-1].to_f

 price_html=doc.xpath("//html/body/div[3]/div[2]/div[2]/div/table/tr[3]/td[3]")
 price_text = price_html.inner_text[1..-1]
 price = price_text.to_f
 #puts price_html,price_text,price
 price
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

