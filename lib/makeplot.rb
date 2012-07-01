def makeplot(prices)
   plotdata='var plotdata = ['
   prices.each do |p|
        plotdata=plotdata+ "[#{p.scraped_at.to_i*1000},#{ p.price}],"
   end
   plotdata=plotdata[0..-2] #remove trailing comma ","
   plotdata=plotdata+"]\n"

plothead=<<PLOT
$(function () {
PLOT
plottail=<<PLOT
      
      var placeholder = $("#coop");
      var options = {
          series: {
            points: {show:true},
            lines: { show: true },
            shadowSize: 0
          },
          xaxis: {
                  mode: "time",
                  timeformat: "%y/%b",
 
                points: {show: true},
             zoomRange: [(new Date("1999/01/01")).getTime(),(new Date("2012/01/01")).getTime()],
            panRange: [(new Date("1999/01/01")).getTime(),(new Date("2012/01/01")).getTime()],
            minTickSize: [1, "month"],
            lines: {show:true} 
						},

          yaxis: {
            zoomRange: [0, 3],
            panRange: [0, 3]
          },
          zoom: {
              interactive: true
          },
          pan: {
              interactive: true
          }
      };
  
      var plot = $.plot(placeholder, [plotdata], options);
  
      placeholder.bind('plotpan', function (event, plot) {
          var axes = plot.getAxes();
          $(".message").html("Panning to x: "  + axes.xaxis.min.toFixed(4)
                             + " &ndash; " + axes.xaxis.max.toFixed(4)
                             + " and y: " + axes.yaxis.min.toFixed(2)
                             + " &ndash; " + axes.yaxis.max.toFixed(2));
      });
  
      placeholder.bind('plotzoom', function (event, plot) {
          var axes = plot.getAxes();
          $(".message").html("Zooming to x: "  + axes.xaxis.min.toFixed(4)
                             + " &ndash; " + axes.xaxis.max.toFixed(4)
                             + " and y: " + axes.yaxis.min.toFixed(2)
                             + " &ndash; " + axes.yaxis.max.toFixed(2));
      });
  
      // add zoom out button 
      $('<div class="button" style="right:20px;top:20px">zoom out</div>').appendTo(placeholder).click(function (e) {
          e.preventDefault();
          plot.zoomOut();
      });
  
      // and add panning buttons
      
      // little helper for taking the repetitive work out of placing
      // panning arrows
      function addArrow(dir, right, top, offset) {
          $('<img class="button" src="images/arrow-' + dir + '.gif" style="right:' + right + 'px;top:' + top + 'px">').appendTo(placeholder).click(function (e) {
              e.preventDefault();
              plot.pan(offset);
          });
      }
  
      addArrow('left', 55, 60, { left: -100 });
      addArrow('right', 25, 60, { left: 100 });
      addArrow('up', 40, 45, { top: -100 });
      addArrow('down', 40, 75, { top: 100 });
  });

PLOT

   plothead+plotdata+plottail
end


