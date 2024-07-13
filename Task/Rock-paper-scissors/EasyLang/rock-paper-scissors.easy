tool$[] = [ "rock" "paper" "scissors" ]
repeat
   write "choose your weapon: "
   h$ = input
   c = randint 3
   h$ = substr h$ 1 1
   until h$ = "q"
   h = strpos "rps" h$
   if h = 0
      print "that's not a valid choice"
   else
      print tool$[h]
      print "computer: " & tool$[c]
      if h = c
         print "it's a tie!"
      elif (h + 1) mod1 3 = c
         print "yay you win!"
      else
         print "the computer beats you... :("
      .
   .
   print ""
   sleep 1
.
