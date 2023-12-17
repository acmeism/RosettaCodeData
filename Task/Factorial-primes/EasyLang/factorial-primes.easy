func isprim num .
   if num < 2
      return 0
   .
   i = 2
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 1
   .
   return 1
.
f = 1
while count < 10
   n += 1
   f *= n
   op$ = "-"
   for fp in [ f - 1 f + 1 ]
      if isprim fp = 1
         count += 1
         print n & "! " & op$ & " 1 = " & fp
      .
      op$ = "+"
   .
.
