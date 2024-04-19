proc divisors n . divs[] .
   divs[] = [ 1 n ]
   for i = 2 to sqrt n
      if n mod i = 0
         j = n / i
         divs[] &= i
         if i <> j
            divs[] &= j
         .
      .
   .
.
func ispartsum divs[] sum .
   if sum = 0
      return 1
   .
   if len divs[] = 0
      return 0
   .
   last = divs[len divs[]]
   len divs[] -1
   if last > sum
      return ispartsum divs[] sum
   .
   if ispartsum divs[] sum = 1
      return 1
   .
   return ispartsum divs[] (sum - last)
.
func iszumkeller n .
   divisors n divs[]
   for v in divs[]
      sum += v
   .
   if sum mod 2 = 1
      return 0
   .
   if n mod 2 = 1
      abund = sum - 2 * n
      return if abund > 0 and abund mod 2 = 0
   .
   return ispartsum divs[] (sum / 2)
.
#
print "The first 220 Zumkeller numbers are:"
i = 2
repeat
   if iszumkeller i = 1
      write i & " "
      count += 1
   .
   until count = 220
   i += 1
.
print "\n\nThe first 40 odd Zumkeller numbers are:"
count = 0
i = 3
repeat
   if iszumkeller i = 1
      write i & " "
      count += 1
   .
   until count = 40
   i += 2
.
