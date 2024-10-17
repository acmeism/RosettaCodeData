col[] = [ 997 977 ]
subr initvars
   sum = 0
   stat = 0
   sum[] = [ 0 0 ]
   player = 1
.
proc btn x y txt$ . .
   color 666
   linewidth 18
   move x y
   line x + 15 y
   move x - 4 y - 3
   color 000
   textsize 10
   text txt$
.
proc show . .
   background col[player]
   clear
   move 8 78
   color 000
   textsize 10
   text "Player-" & player
   textsize 8
   move 8 66
   text "Total: " & sum[player]
   textsize 5
   #
   h = 3 - player
   color col[h]
   move 65 63
   rect 30 19
   move 68 74
   color 000
   text "Player-" & h
   textsize 4
   move 68 67
   text "Total: " & sum[h]
   #
   btn 20 20 "Roll"
   btn 70 20 "Hold"
.
proc nxtplayer . .
   sum[player] += sum
   if sum > 0
      sum = 0
      show
   .
   move 10 92
   textsize 7
   color 000
   if sum[player] >= 100
      text "You won !"
      stat = 3
   else
      text "Switch player ..."
      player = 3 - player
      stat = 2
   .
   timer 2
.
on timer
   if stat = 1
      # roll
      if tmcnt = 0
         move 44 37
         color col[player]
         rect 30 10
         if dice > 1
            sum += dice
            stat = 0
         else
            sum = 0
         .
         color 000
         text sum
         if dice = 1
            nxtplayer
         .
      else
         color 555
         move 24 34
         rect 13 13
         color 000
         move 27 37
         dice = random 6
         text dice
         tmcnt -= 1
         if tmcnt = 0
            timer 0.5
         else
            timer 0.1
         .
      .
   elif stat = 2
      stat = 0
      show
   elif stat = 3
      move 0 0
      color col[player]
      rect 100 30
      color 000
      move 10 30
      text "Click for new game"
      stat = 4
   .
.
proc roll . .
   stat = 1
   tmcnt = 10
   textsize 10
   timer 0
.
on mouse_down
   if stat = 0
      if mouse_x > 10 and mouse_x < 45 and mouse_y > 10 and mouse_y < 30
         roll
      elif mouse_x > 60 and mouse_x < 95 and mouse_y > 10 and mouse_y < 30
         nxtplayer
      .
   elif stat = 4
      initvars
      show
   .
.
initvars
show
