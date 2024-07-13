func[] propdivs n .
   if n < 2
      return [ ]
   .
   divs[] &= 1
   sqr = sqrt n
   for d = 2 to sqr
      if n mod d = 0
         divs[] &= d
         if d <> sqr
            divs[] &= n / d
         .
      .
   .
   return divs[]
.
for i to 10
   print i & ":" & propdivs i
.
for i to 20000
   d[] = propdivs i
   if len d[] > max
      max = len d[]
      maxi = i
   .
.
print maxi & " has " & max & " proper divisors."
