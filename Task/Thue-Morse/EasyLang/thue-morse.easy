func$ tmorse s$ .
   for i to len s$
      if substr s$ i 1 = "1"
         k$ &= "0"
      else
         k$ &= "1"
      .
   .
   return s$ & k$
.
tm$ = "0"
print tm$
for j to 7
   tm$ = tmorse tm$
   print tm$
.
