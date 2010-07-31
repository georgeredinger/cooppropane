def makeplot(prices)

   plotdata='var d = ['
   prices.each do |p|
        plotdata=plotdata+ "[#{p.scraped_at.to_i*1000},#{ p.price}],"
   end
   plotdata=plotdata[0..-2] #remove trailing comma ","
   plotdata=plotdata+"]\n"

plothead=<<PLOT
$(function () {
PLOT

plottail=<<PLOT
      $.plot($("#coop"), [d], { xaxis: { mode: "time" } });
   
  
      $("#ninetynine").click(function () {
          $.plot($("#coop"), [d], {
              xaxis: {
                  mode: "time",
                  minTickSize: [1, "month"],
                  min: (new Date("1999/01/01")).getTime(),
                  max: (new Date("2000/01/01")).getTime()
              }
          });
      });
  });
PLOT
   plothead+plotdata+plottail
end

