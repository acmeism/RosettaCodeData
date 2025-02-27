s$ = "Hello world! "
textsize 14
lg = len s$
on timer
   color 333
   move 10 20
   rect 80 20
   color 999
   move 12 24
   text substr s$ 1 9
   if forw = 1
      s$ = substr s$ lg 1 & substr s$ 1 (lg - 1)
   else
      s$ = substr s$ 2 (lg - 1) & substr s$ 1 1
   .
   timer 0.4
.
on mouse_down
   if mouse_x > 10 and mouse_x < 90
      if mouse_y > 20 and mouse_y < 40
         forw = 1 - forw
      .
   .
.
timer 0
