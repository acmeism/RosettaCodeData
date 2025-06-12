fastfunc isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 1
   .
   return 1
.
func gcd a b .
   while b <> 0
      h = b
      b = a mod b
      a = h
   .
   return a
.
func sumdiv num .
   d = 2
   repeat
      quot = num div d
      until d > quot
      if num mod d = 0
         sum += d
         if d <> quot : sum += quot
      .
      d += 1
   .
   return sum + 1
.
func isduff n .
   if isprim n = 0 and gcd sumdiv n n = 1
      return 1
   .
   return 0
.
proc duffs .
   print "First 50 Duffinian numbers:"
   n = 4
   repeat
      if isduff n = 1
         write n & " "
         cnt += 1
      .
      until cnt = 50
      n += 1
   .
   cnt = 0
   n = 4
   print "\n\nFirst 15 Duffinian triplets:"
   repeat
      if isduff n = 1 and isduff (n + 1) = 1 and isduff (n + 2) = 1
         print n & " - " & n + 2
         cnt += 1
      .
      until cnt = 15
      n += 1
   .
.
duffs
