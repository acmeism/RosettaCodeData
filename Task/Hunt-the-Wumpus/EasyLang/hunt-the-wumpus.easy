exits[][] = [ [ 2 5 8 ] [ 1 3 10 ] [ 2 4 12 ] [ 3 5 14 ] [ 1 4 6 ] [ 5 7 15 ] [ 6 8 17 ] [ 1 7 9 ] [ 8 10 18 ] [ 2 9 11 ] [ 10 12 19 ] [ 2 11 13 ] [ 12 14 20 ] [ 4 13 15 ] [ 6 14 16 ] [ 15 17 20 ] [ 7 16 18 ] [ 9 17 19 ] [ 11 18 20 ] [ 13 16 19 ] ]
len hazard$[] 20
func emptyRoom .
   repeat
      room = random 20
      until hazard$[room] = ""
   .
   return room
.
for i to 2
   hazard$[emptyRoom] = "bat"
   hazard$[emptyRoom] = "pit"
.
hazard$[emptyRoom] = "wumpus"
#
print "*** HUNT THE WUMPUS ***"
print "-----------------------"
curRoom = emptyRoom
arrows = 5
func checkWumpus .
   if hazard$[curRoom] = "wumpus"
      print "You find yourself face to face with the wumpus."
      print "It eats you whole."
      print "GAME OVER"
      return 1
   .
.
repeat
   print "You are in room " & curRoom & "."
   until checkWumpus = 1
   for r in exits[curRoom][]
      if hazard$[r] = "wumpus" : print "You smell something terrible nearby."
      if hazard$[r] = "bat" : print "You hear a rustling."
      if hazard$[r] = "pit" : print "You feel a cold wind blowing from a nearby cavern."
   .
   print "Tunnels lead to: " & strjoin exits[curRoom][] ", "
   print "You have " & arrows & " arrows."
   print ""
   repeat
      repeat
         write "M)ove, S)hoot, or Q)uit? "
         in$ = input
         print in$
         m$ = substr in$ 1 1
         until m$ = "m" or m$ = "s" or m$ = "q"
      .
      if m$ = "q" : break 2
      target = number substr in$ 2 99
      if target = 0
         write "Which room? "
         target = number input
         print target
      .
      for i to 3
         if exits[curRoom][i] = target : break 1
      .
      until i <= 3
      print "Cannot get there from here."
   .
   if m$ = "m"
      curRoom = target
      if hazard$[curRoom] = "bat"
         print "You have entered the lair of a giant bat."
         curRoom = emptyRoom
         print "It picks you up and drops you in room " & curRoom & "."
      elif hazard$[curRoom] = "pit"
         print "The ground gives way beneath your feet."
         print "You fall into a deep abyss."
         print "GAME OVER"
         break 1
      .
   else
      arrows -= 1
      if hazard$[target] = "wumpus"
         print "Congratulations!  You shot the wumpus!"
         break 1
      .
      print "You missed."
      if randomf < 0.75
         print "The wumpus wakes from his slumber."
         for i to 20 : if hazard$[i] = "wumpus" : hazard$[i] = ""
         hazard$[emptyRoom] = "wumpus"
         if checkWumpus = 1 : break 1
      .
      if arrows = 0
         print "As you grasp at your empty quiver, "
         print "you hear a large beast approaching..."
         hazard$[curRoom] = "wumpus"
         if checkWumpus = 1 : break 1
      .
   .
.
