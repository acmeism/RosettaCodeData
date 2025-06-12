proc draw hour min sec .
   # dial
   gcolor 333
   gcircle 50 50 45
   gcolor 797
   gcircle 50 50 44
   gcolor 333
   for i range0 60
      a = i * 6
      if i mod 5 = 0
         gcircle 50 + sin a * 40 50 + cos a * 40 1
      else
         gcircle 50 + sin a * 40 50 + cos a * 40 0.25
      .
   .
   # hour
   glinewidth 2
   gcolor 000
   a = (hour * 60 + min) / 2
   gline 50 50 50 + sin a * 32 50 + cos a * 32
   # min
   glinewidth 1.5
   a = (sec + min * 60) / 10
   gline 50 50 50 + sin a * 40 50 + cos a * 40
   # sec
   glinewidth 1
   gcolor 700
   a = sec * 6
   gline 50 50 50 + sin a * 40 50 + cos a * 40
.
on timer
   if t <> floor systime
      t = floor systime
      h$ = timestr t
      sec = number substr h$ 18 2
      min = number substr h$ 15 2
      hour = number substr h$ 12 2
      if hour > 12 : hour -= 12
      draw hour min sec
   .
   timer 0.05
.
timer 0
