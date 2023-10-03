subr fruit
   rx = (random 20 - 1) * 5 + 2.5
   ry = (random 20 - 1) * 5 + 2.5
.
subr start
   fruit
   game = 1
   sx[] = [ 52.5 0 0 0 0 ]
   sy[] = [ 52.5 0 0 0 0 ]
   dir = random 4
   timer 0
.
background 242
move 30 70
clear
color 997
text "SNAKE"
textsize 5
move 6 40
text "Keys or mouse for controlling"
move 6 30
text "Space or click to to start"
#
on key
   if game = 0 and keybkey = " "
      start
      return
   .
   if dir mod 2 = 1
      if keybkey = "ArrowRight"
         dir = 2
      elif keybkey = "ArrowLeft"
         dir = 4
      .
   else
      if keybkey = "ArrowUp"
         dir = 1
      elif keybkey = "ArrowDown"
         dir = 3
      .
   .
.
on mouse_down
   if game = 0
      start
      return
   .
   if dir mod 2 = 1
      if mouse_x < sx
         dir = 4
      else
         dir = 2
      .
   else
      if mouse_y < sy
         dir = 3
      else
         dir = 1
      .
   .
.
on timer
   clear
   color 997
   move 2 95
   text "Score: " & 10 * len sx[] - 50
   color 966
   move rx ry
   circle 1.5
   #
   sx = sx[1] ; sy = sy[1]
   if dir = 1
      sy += 5
   elif dir = 2
      sx += 5
   elif dir = 3
      sy -= 5
   elif dir = 4
      sx -= 5
   .
   if sx < 0 or sx > 100 or sy < 0 or sy > 100
      game = 0
   .
   color 494
   for i = len sx[] downto 2
      if sx = sx[i] and sy = sy[i]
         game = 0
      .
      sx[i] = sx[i - 1]
      sy[i] = sy[i - 1]
      if sx[i] > 0
         move sx[i] sy[i]
         circle 2.5
      .
   .
   move sx sy
   circle 2.5
   color 000
   if dir = 2 or dir = 4
      move sx sy + 1
      circle 0.5
      move sx sy - 1
      circle 0.5
   else
      move sx + 1 sy
      circle 0.5
      move sx - 1 sy
      circle 0.5
   .
   if sx = rx and sy = ry
      len sx[] len sx[] + 3
      len sy[] len sy[] + 3
      fruit
   .
   sx[1] = sx ; sy[1] = sy
   if game = 1
      timer 0.15
   else
      color 997
      move 10 10
      text "Space or click new game"
   .
.
