len cell[] 56
len cnt[] 56
len flag[] 56
#
subr initvars
   state = 0
   ticks = 0
   indx = -1
   no_time = 0
.
func getind r c .
   ind = -1
   if r >= 0 and r <= 6 and c >= 0 and c <= 7
      ind = r * 8 + c + 1
   .
   return ind
.
proc draw_cell ind h . .
   ind -= 1
   r = ind div 8
   c = ind mod 8
   x = c * 12 + 2.5
   y = r * 12 + 2.5
   move x y
   rect 11 11
   if h > 0
      # count
      move x + 3 y + 3
      color 000
      text h
   elif h = -3
      # flag
      x += 4
      color 000
      linewidth 0.8
      move x y + 3
      line x y + 8
      color 600
      linewidth 2
      move x + 0.5 y + 7
      line x + 2 y + 7
   elif h <> 0
      # mine
      color 333
      if h = -2
         color 800
      .
      move x + 5 y + 5
      circle 3
      line x + 8 y + 9
   .
.
proc open ind . .
   if ind <> -1 and cell[ind] = 0
      cell[ind] = 2
      flag[ind] = 0
      color 686
      draw_cell ind cnt[ind]
      if cnt[ind] = 0
         ind -= 1
         r0 = ind div 8
         c0 = ind mod 8
         for r = r0 - 1 to r0 + 1
            for c = c0 - 1 to c0 + 1
               if r <> r0 or c <> c0
                  open getind r c
               .
            .
         .
      .
   .
.
proc show_mines m . .
   for ind to 56
      if cell[ind] = 1
         color 686
         if m = -1
            color 353
         .
         draw_cell ind m
      .
   .
.
proc outp col s$ . .
   move 2.5 87
   color col
   rect 59 11
   color 000
   move 5 90
   text s$
.
proc upd_info . .
   for i to 56
      nm += flag[i]
      if cell[i] < 2
         nc += 1
      .
   .
   if nc = 8
      outp 484 "Well done"
      show_mines -1
      state = 1
   else
      outp 464 8 - nm & " mines left"
   .
.
proc test ind . .
   if cell[ind] < 2 and flag[ind] = 0
      if cell[ind] = 1
         show_mines -1
         color 686
         draw_cell ind -2
         outp 844 "B O O M !"
         state = 1
      else
         open ind
         upd_info
      .
   .
.
background 676
proc start . .
   clear
   color 353
   for ind to 56
      cnt[ind] = 0
      cell[ind] = 0
      flag[ind] = 0
      draw_cell ind 0
   .
   n = 8
   while n > 0
      c = randint 8 - 1
      r = randint 7 - 1
      ind = r * 8 + c + 1
      if cell[ind] = 0
         n -= 1
         cell[ind] = 1
         for rx = r - 1 to r + 1
            for cx = c - 1 to c + 1
               ind = getind rx cx
               if ind > -1
                  cnt[ind] += 1
               .
            .
         .
      .
   .
   initvars
   outp 464 ""
   textsize 4
   move 5 93
   text "Minesweeper - 8 mines"
   move 5 88.2
   text "Long-press for flagging"
   textsize 6
   timer 0
.
on mouse_down
   if state = 0
      if mouse_y > 86 and mouse_x > 60
         no_time = 1
         move 64.5 87
         color 464
         rect 33 11
      .
      indx = getind ((mouse_y - 2) div 12) ((mouse_x - 2) div 12)
      ticks0 = ticks
   elif state = 3
      start
   .
.
on mouse_up
   if state = 0 and indx <> -1
      test indx
   .
   indx = -1
.
on timer
   if state = 1
      state = 2
      timer 1
   elif state = 2
      state = 3
   elif no_time = 0 and ticks > 3000
      outp 844 "B O O M !"
      show_mines -2
      state = 2
      timer 1
   else
      if indx > 0 and ticks = ticks0 + 2
         if cell[indx] < 2
            color 353
            flag[indx] = 1 - flag[indx]
            opt = 0
            if flag[indx] = 1
               opt = -3
            .
            draw_cell indx opt
            upd_info
         .
         indx = -1
      .
      if no_time = 0 and ticks mod 10 = 0
         move 64.5 87
         color 464
         if ticks >= 2500
            color 844
         .
         rect 33 11
         color 000
         move 66 90
         text "Time:" & 300 - ticks / 10
      .
      ticks += 1
      timer 0.1
   .
.
start
