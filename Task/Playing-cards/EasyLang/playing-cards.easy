global deck[] top .
proc new . .
   deck[] = [ ]
   for i to 52
      deck[] &= i
   .
   top = 52
.
suit$[] = [ "♠" "♦" "♥" "♣" ]
val$[] = [ 2 3 4 5 6 7 8 9 10 "J" "Q" "K" "A" ]
func$ name card .
   return suit$[card mod1 4] & val$[card div1 4]
.
proc show . .
   for i to top
      write name deck[i] & " "
   .
   print ""
   print ""
.
proc shuffle . .
   for i = 52 downto 2
      r = random i
      swap deck[i] deck[r]
   .
   top = 52
.
func deal .
   top -= 1
   return deck[top + 1]
.
new
show
shuffle
show
for i to 10
   write name deal & " "
.
print ""
print ""
show
