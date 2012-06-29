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
      $.plot($("#coop"), [d], { xaxis: { mode: "time", timeformat: "%y/%b" },points: {show: true},lines: {show:true} });
   
  
      $("#ninetynine").click(function () {
          $.plot($("#coop"), [d], {
              xaxis: {
                  mode: "time",
                  minTickSize: [1, "month"],
                  min: (new Date("1999/01/01")).getTime(),
                  max: (new Date("2000/01/01")).getTime()
              },
							zoom: {
							    interactive: true,
									trigger: "dblclick", // or "click" for single click
									amount: 1.5         // 2 = 200% (zoom in), 0.5 = 50% (zoom out)
						},
						pan: {
						    interactive: true
					 }
          });
      });
  });
PLOT
   plothead+plotdata+plottail
end

