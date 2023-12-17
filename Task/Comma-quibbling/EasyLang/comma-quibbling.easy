func$ tolist s$ .
   s$[] = strsplit s$ " "
   r$ = "{"
   n = len s$[]
   for i = 1 to n - 2
      r$ &= s$[i] & ", "
   .
   if n > 0
      if n > 1
         r$ &= s$[n - 1] & " and "
      .
      r$ &= s$[n]
   .
   r$ &= "}"
   return r$
.
print tolist ""
print tolist "ABC"
print tolist "ABC DEF"
print tolist "ABC DEF G H"
