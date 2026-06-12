see "working..." + nl
decimals(3)
time1 = clock()
for num = 1 to 5
    pRand()
next

time2 = clock()
time3 = time2/1000 - time1/1000
see "Elapsed time = " + time3 + " s" + nl
see "done..." + nl

func pRand
     randCheck = list(20)
     while true
           rnd = random(19)+1
           if randCheck[rnd] = 1
              loop
           else
              randCheck[rnd] = 1
              see "" + rnd + " "
           ok
           nr = 1
           for n = 1 to len(randCheck)
               if randCheck[nr] = 1
                  nr++
               ok
           next
           if nr = 21
              see nl
              exit
           ok
     end
