proc addNoCells &cells$ .
   l$ = "OO"
   r$ = "OO"
   if substr cells$ 1 1 = "O" : l$ = ".."
   if substr cells$ len cells$ 1 = "O" : r$ = ".."
   cells$ = l$ & cells$ & r$
.
proc step &cells$ rule .
   for i = 1 to len cells$ - 2
      bin = 0
      b = 2
      for n = i to i + 2
         if substr cells$ n 1 = "O" : bin += bitshift 1 b
         b = bitshift b -1
      .
      a$ = "."
      if bitand rule bitshift 1 bin <> 0 : a$ = "O"
      ncells$ &= a$
   .
   swap cells$ ncells$
.
proc evolve l rule .
   print " Rule #" & rule
   cells$ = "O"
   for i = 1 to l
      addNoCells cells$
      for j to 30 - len cells$ div 2 : write " "
      print cells$
      step cells$ rule
   .
   print ""
.
evolve 25 90
evolve 25 30
