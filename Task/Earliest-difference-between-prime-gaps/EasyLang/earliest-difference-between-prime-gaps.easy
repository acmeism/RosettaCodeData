fastfunc nextPrimeOdd n .
   i = n + 2
   repeat
      j = 3
      while j <= sqrt i and i mod j <> 0
         j += 2
      .
      until j > sqrt i
      i += 2
   .
   return i
.
lastPrime = 3
len gapStarts[] 1e7
#
func findGapStart gap .
   if gapStarts[gap] <> 0 : return gapStarts[gap]
   repeat
      prev = lastPrime
      lastPrime = nextPrimeOdd lastPrime
      diff = lastPrime - prev
      if gapStarts[diff] = 0 : gapStarts[diff] = prev
      until gap = diff
   .
   return prev
.
#
gap = 2
pm = 10
repeat
   start1 = findGapStart gap
   start2 = findGapStart (gap + 2)
   diff = abs (start2 - start1)
   if diff > pm
      print "> " & pm & ": gaps " & gap & "/" & gap + 2 & " range " & start1 & "-" & start2 & " (" & diff & ")"
      pm *= 10
   else
      gap += 2
   .
   until pm = 1e7
.
