# Project : Mastermind

colors = ["A", "B", "C", "D"]
places = list(2)
mind = list(len(colors))
rands = list(len(colors))
master = list(len(colors))
test = list(len(colors))
guesses  = 7
repeat = false
nr = 0

if repeat
   for n = 1 to len(colors)
        while true
                  rnd = random(len(colors)-1) + 1
                  if rands[rnd] != 1
                     mind[n] = rnd
                     rands[rnd] = 1
                    exit
                  ok
        end
   next
else
   for n = 1 to len(colors)
        rnd = random(len(colors)-1) + 1
        mind[n] = rnd
    next
ok

for n = 1 to len(colors)
      master[n] = char(64+mind[n])
next
while true
         for p = 1 to len(places)
               places[p] = 0
         next
         nr = nr + 1
         see "Your guess (ABCD)? "
         give testbegin
         for d = 1 to len(test)
               test[d] = testbegin[d]
         next
         flag = 1
         for n = 1 to len(test)
               if upper(test[n]) != master[n]
                  flag = 0
               ok
         next
         if flag = 1
            exit
         else
            for x = 1 to len(master)
                  if upper(test[x]) = master[x]
                      places[1] = places[1] + 1
                  ok
            next
            mastertemp = master
            for p = 1 to len(test)
                  pos = find(mastertemp, upper(test[p]))
                  if pos > 0
                     del(mastertemp, pos)
                     places[2] = places[2] + 1
                  ok
            next
         ok
         place1 = places[1]
         place2 = places[2] - place1
         place3 = len(master) - (place1 + place2)
         showresult(test, place1, place2, place3)
         if nr = guesses
            exit
         ok
end
see "Well done!" + nl
see "End of game" + nl

func showresult(test, place1, place2, place3)
        see "" + nr + " : "
        for r = 1 to len(test)
             see test[r]
        next
        see " : "
        for n1 = 1 to place1
              see "X" + " "
        next
        for n2 = 1 to place2
              see "O" + " "
        next
        for n3 = 1 to place3
              see "-" + " "
        next
        see nl
