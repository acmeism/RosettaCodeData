target$ = "METHINKS IT IS LIKE A WEASEL"
abc$[] = strchars " ABCDEFGHIJLKLMNOPQRSTUVWXYZ"
P = 0.05
C = 100
func fitness trial$ .
   for i to len trial$
      res += if substr trial$ i 1 <> substr target$ i 1
   .
   return res
.
func$ mutate parent$ .
   for c$ in strchars parent$
      if randomf < P
         res$ &= abc$[randint len abc$[]]
      else
         res$ &= c$
      .
   .
   return res$
.
for i to len target$
   parent$ &= abc$[randint len abc$[]]
.
while fitness parent$ > 0
   copies$[] = [ ]
   for i to C
      copies$[] &= mutate parent$
   .
   parent$ = copies$[1]
   for s$ in copies$[]
      if fitness s$ < fitness parent$
         parent$ = s$
      .
   .
   step += 1
   print step & " " & parent$
.
