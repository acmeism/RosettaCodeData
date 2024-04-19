func digsum n sum .
   sum += 1
   while n > 0 and n mod 10 = 0
      sum -= 9
      n = n div 10
   .
   return sum
.
func divisible n d .
   if d mod 2 = 0 and n mod 2 = 1
      return 0
   .
   return if n mod d = 0
.
numfmt 0 8
previous = 1
print " Gap index    Gap  Niven index  Niven number"
print " ---------    ---  -----------  ------------"
for niven = 1 to 10000000
   sum = digsum niven sum
   if divisible niven sum = 1
      if niven > previous + gap
         gap_index += 1
         gap = niven - previous
         print gap_index & gap & " " & niven_index & "    " & previous
      .
      previous = niven
      niven_index += 1
   .
.
