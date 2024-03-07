print "Who reaches 21, wins"
print "Do you want to begin (y/n)"
who = 1
if input = "n"
  who = 2
.
who$[] = [ "Human" "Computer" ]
repeat
  if who = 1
    repeat
      print ""
      print "Choose 1,2 or 3 (q for quit)"
      a$ = input
      n = number a$
      until a$ = "q" or (n >= 1 and n <= 3)
    .
  else
    sleep 1
    if sum mod 4 = 1
      n = randint 3
    else
      n = 4 - (sum + 3) mod 4
    .
  .
  sum += n
  print who$[who] & ": " & n & " --> " & sum
  until sum >= 21 or a$ = "q"
  who = who mod 2 + 1
.
if a$ <> "q"
  print ""
  if who = 0
    print "Congratulation, you won"
  else
    print "Sorry, you lost"
  .
.
