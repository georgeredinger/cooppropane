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
            shadowSize: 0,
						clickable:true,
            hoverable: true
          },
          xaxis: {
                  mode: "time",
                  timeformat: "%y/%b",
                  points: {show: true},
                  lines: {show:true}, 
                  zoomRange: [(new Date("1999/01/01")).getTime(),(new Date("2014/01/01")).getTime()],
                  panRange: [(new Date("1999/01/01")).getTime(),(new Date("2014/01/01")).getTime()],
                  //minTickSize: [1, "month"],
									ticks: 36,
									alignTicksWithAxis: 1
						},

          yaxis: {
            zoomRange: [1, 3],
            panRange: [1, 3]
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
  
      $('<div class="button" style="right:20px;top:20px">zoom out</div>').appendTo(placeholder).click(function (e) {
          e.preventDefault();
          plot.zoomOut();
      });

      function rotateXlabels() {
        $('.xtickLabel').css({
                              'top':'391px',
                              '-webkit-transform':'rotate(45deg)',
                              '-moz-transform':'rotate(45deg)',
                              '-ms-transform':'rotate(45deg)',
                              'filter':'progid:DXImageTransform.Microsoft.BasicImage(rotation=0.5)'
                            });
      }

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
//			rotateXlabels();
   });

PLOT

   plothead+plotdata+plottail
end


