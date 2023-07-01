Red [
	Needs: 'View
	Purpose: {simple analog clock based on Nenad Rakocevic's eve-clock.red,
see http://www.red-lang.org/2016/07/eve-style-clock-demo-in-red-livecoded.html}
]

view [ base 100x100 transparent rate 1 now draw [
   circle 50x50 45
   hour: rotate 0 50x50 [pen #023963 line 50x50 50x20]
   min:  rotate 0 50x50 [pen #023963 line 50x50 50x10]
   sec:  rotate 0 50x50 [pen #CE0B46 line 50x50 50x10]
] on-time [
   time: now/time
   hour/2: 30 * time/hour
   min/2:  6  * time/minute
   sec/2:  6  * time/second
]]
