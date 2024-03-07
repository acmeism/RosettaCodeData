len f[] 9
state = 0
textsize 14
#
proc init . .
   linewidth 2
   clear
   color 666
   move 34 96
   line 34 20
   move 62 96
   line 62 20
   move 10 72
   line 86 72
   move 10 44
   line 86 44
   linewidth 2.5
   for i = 1 to 9
      f[i] = 0
   .
   if state = 1
      timer 0.2
   .
.
proc draw ind . .
   c = (ind - 1) mod 3
   r = (ind - 1) div 3
   x = c * 28 + 20
   y = r * 28 + 30
   if f[ind] = 4
      color 900
      move x - 7 y - 7
      line x + 7 y + 7
      move x + 7 y - 7
      line x - 7 y + 7
   elif f[ind] = 1
      color 009
      move x y
      circle 10
      color -2
      circle 7.5
   .
.
proc sum3 a d . st .
   for i = 1 to 3
      s += f[a]
      a += d
   .
   if s = 3
      st = -1
   elif s = 12
      st = 1
   .
.
proc rate . res done .
   res = 0
   for i = 1 step 3 to 7
      sum3 i 1 res
   .
   for i = 1 to 3
      sum3 i 3 res
   .
   sum3 1 4 res
   sum3 3 2 res
   cnt = 1
   for i = 1 to 9
      if f[i] = 0
         cnt += 1
      .
   .
   res *= cnt
   done = 1
   if res = 0 and cnt > 1
      done = 0
   .
.
proc minmax player alpha beta . rval rmov .
   rate rval done
   if done = 1
      if player = 1
         rval = -rval
      .
   else
      rval = alpha
      start = randint 9
      mov = start
      repeat
         if f[mov] = 0
            f[mov] = player
            minmax (5 - player) (-beta) (-rval) val h
            val = -val
            f[mov] = 0
            if val > rval
               rval = val
               rmov = mov
            .
         .
         mov = mov mod 9 + 1
         until mov = start or rval >= beta
      .
   .
.
proc show_result val . .
   color 555
   move 16 4
   if val < 0
      # this never happens
      text "You won"
   elif val > 0
      text "You lost"
   else
      text "Tie"
   .
   state += 2
.
proc computer . .
   minmax 4 -11 11 val mov
   f[mov] = 4
   draw mov
   rate val done
   state = 0
   if done = 1
      show_result val
   .
.
proc human . .
   mov = floor ((mouse_x - 6) / 28) + 3 * floor ((mouse_y - 16) / 28) + 1
   if f[mov] = 0
      f[mov] = 1
      draw mov
      state = 1
      timer 0.5
   .
.
on timer
   rate val done
   if done = 1
      show_result val
   else
      computer
   .
.
on mouse_down
   if state = 0
      if mouse_x > 6 and mouse_x < 90 and mouse_y > 16
         human
      .
   elif state >= 2
      state -= 2
      init
   .
.
init
