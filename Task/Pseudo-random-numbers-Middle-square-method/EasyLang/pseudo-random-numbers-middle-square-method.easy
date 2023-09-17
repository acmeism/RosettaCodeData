global seed .
seed = 675248
func rand .
   strSeed$ = seed
   s$ = seed * seed
   while not len s$ = len strSeed$ * 2
      s$ = "0" & s$
   .
   seed = number substr s$ (len strSeed$ / 2 + 1) len strSeed$
   randNum = seed
   return randNum
.
for i = 1 to 5
   print rand
.
