sysconf topleft
gbackground 432
gtextsize 13
len f[] 16
proc draw .
   gclear
   for i = 1 to 16
      v = f[i]
      if v < 16
         x = (i - 1) mod 4 * 24 + 3
         y = (i - 1) div 4 * 24 + 3
         gcolor 210
         grect x y 22 22
         if v < 10 : x += 2
         gcolor 885
         gtext x + 4 y + 6 v
      .
   .
.
proc smiley .
   s = 3.5
   x = 86
   y = 86
   gcolor 983
   gcircle x y 2.8 * s
   gcolor 000
   gcircle (x - s) (y - s) (s / 3)
   gcircle x + 3.5 y - 3.5 s / 3
   glinewidth s / 3
   gcurve [ x - s y + s x y + 2 * s x + s y + s ]
.
global done .
proc init .
   done = 0
   for i = 1 to 16 : f[i] = i
   # shuffle
   for i = 15 downto 2
      r = random i
      swap f[r] f[i]
   .
   # make it solvable
   inv = 0
   for i = 1 to 15 : for j = 1 to i - 1
      if f[j] > f[i] : inv += 1
   .
   if inv mod 2 <> 0 : swap f[1] f[2]
   gtextsize 12
   draw
.
proc move_tile .
   c = mouse_x div 25
   r = mouse_y div 25
   i = r * 4 + c + 1
   if c > 0 and f[i - 1] = 16
      swap f[i] f[i - 1]
   elif r > 0 and f[i - 4] = 16
      swap f[i] f[i - 4]
   elif r < 3 and f[i + 4] = 16
      swap f[i] f[i + 4]
   elif c < 3 and f[i + 1] = 16
      swap f[i] f[i + 1]
   .
   draw
   for i = 1 to 15
      if f[i] > f[i + 1] : return
   .
   done = 1
   timer 0.5
.
on mouse_down
   if done = 0
      move_tile
   elif done = 3 and mouse_x > 75 and mouse_y > 75
      init
   .
.
on timer
   if done = 1
      smiley
      done = 2
      timer 2
   else
      done = 3
   .
.
init
