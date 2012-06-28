/* Copyright (c) 2008 Kean Loong Tan http://www.gimiti.com/kltan
 * Licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
 * jFlow
 * Version: 1.2 (July 7, 2008)
 * Requires: jQuery 1.2+
 */

(function(jQuery) {

	jQuery.fn.jFlow = function(options) {
		var opts = jQuery.extend({}, jQuery.fn.jFlow.defaults, options);
		var randNum = Math.floor(Math.random()*11);
		var jFC = opts.controller;
		var jFS =  opts.slideWrapper;
		var jSel = opts.selectedWrapper;

		var cur = 0;
		var timer;
		var maxi = jQuery(jFC).length;
		// sliding function
		var slide = function (dur, i) {
			jQuery(opts.slides).children().css({
				overflow:"hidden"
			});
			jQuery(opts.slides + " iframe").hide().addClass("temp_hide");
			jQuery(opts.slides).animate({
				marginLeft: "-" + (i * jQuery(opts.slides).find(":first-child").width() + "px")
				},
				opts.duration*(dur),
				opts.easing,
				function(){
					jQuery(opts.slides).children().css({
						overflow:"hidden"
					});
					jQuery(".temp_hide").show();
				}
			);
			
		}
		jQuery(this).find(jFC).each(function(i){
			jQuery(this).click(function(){
				dotimer();
				if (jQuery(opts.slides).is(":not(:animated)")) {
					jQuery(jFC).removeClass(jSel);
					jQuery(this).addClass(jSel);
					var dur = Math.abs(cur-i);
					slide(dur,i);
					cur = i;
				}
			});
		});	
		
		jQuery(opts.slides).before('<div id="'+jFS.substring(1, jFS.length)+'"></div>').appendTo(jFS);
		
		jQuery(opts.slides).find("div").each(function(){
			jQuery(this).before('<div class="jFlowSlideContainer"></div>').appendTo(jQuery(this).prev());
		});
		
		//initialize the controller
		jQuery(jFC).eq(cur).addClass(jSel);
		
		var resize = function (x){
			jQuery(jFS).css({
				position:"relative",
				width: opts.width,
				height: opts.height,
				overflow: "hidden"
			});
			//opts.slides or #mySlides container
			jQuery(opts.slides).css({
				position:"relative",
				width: jQuery(jFS).width()*jQuery(jFC).length+"px",
				height: jQuery(jFS).height()+"px",
				overflow: "hidden"
			});
			// jFlowSlideContainer
			jQuery(opts.slides).children().css({
				position:"relative",
				width: jQuery(jFS).width()+"px",
				height: jQuery(jFS).height()+"px",
				"float":"left",
				overflow:"hidden"
			});
			
			jQuery(opts.slides).css({
				marginLeft: "-" + (cur * jQuery(opts.slides).find(":eq(0)").width() + "px")
			});
		}
		
		// sets initial size
		resize();

		// resets size
		jQuery(window).resize(function(){
			resize();						  
		});
		
		jQuery(opts.prev).click(function(){
			dotimer();
			doprev();
			
		});
		
		jQuery(opts.next).click(function(){
			dotimer();
			donext();
			
		});
		
		var doprev = function (x){
			if (jQuery(opts.slides).is(":not(:animated)")) {
				var dur = 1;
				if (cur > 0)
					cur--;
				else {
					cur = maxi -1;
					dur = cur;
				}
				jQuery(jFC).removeClass(jSel);
				slide(dur,cur);
				jQuery(jFC).eq(cur).addClass(jSel);
			}
		}
		
		var donext = function (x){
			if (jQuery(opts.slides).is(":not(:animated)")) {
				var dur = 1;
				if (cur < maxi - 1)
					cur++;
				else {
					cur = 0;
					dur = maxi -1;
				}
				jQuery(jFC).removeClass(jSel);
				//$(jFS).fadeOut("fast");
				slide(dur, cur);
				//$(jFS).fadeIn("fast");
				jQuery(jFC).eq(cur).addClass(jSel);
			}
		}
		
		var dotimer = function (x){
			if((opts.auto) == true) {
				if(timer != null) 
					clearInterval(timer);
			    
        		timer = setInterval(function() {
	                	jQuery(opts.next).click();
						}, 5000);
			}
		}

		dotimer();
		
		//Pause/Resume at hover
		jQuery(opts.slides).hover(
			function() {
				clearInterval(timer);
			},
			function() {
				dotimer();
			}
		);
	};
	
	jQuery.fn.jFlow.defaults = {
		controller: ".jFlowControl", // must be class, use . sign
		slideWrapper : "#jFlowSlide", // must be id, use # sign
		selectedWrapper: "jFlowSelected",  // just pure text, no sign
		auto: false,
		easing: "swing",
		duration: 400,
		width: "100%",
		prev: ".jFlowPrev", // must be class, use . sign
		next: ".jFlowNext" // must be class, use . sign
	};
	
})(jQuery);