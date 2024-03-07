proc propdivs n . divs[] .
   divs[] = [ ]
   if n < 2
      return
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
.
for i to 10
   propdivs i d[]
   write i & ":"
   print d[]
.
for i to 20000
   propdivs i d[]
   if len d[] > max
      max = len d[]
      maxi = i
   .
.
print maxi & " has " & max & " proper divisors."
