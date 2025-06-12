proc reverse &dig[] i j .
   while i < j
      swap dig[i] dig[j]
      i += 1
      j -= 1
   .
.
proc next_perm &dig[] .
   if len dig[] >= 2
      for i = 2 to len dig[]
         if dig[i] < dig[i - 1]
            k = 1
            while dig[i] >= dig[k] : k += 1
            swap dig[i] dig[k]
            reverse dig[] 1 i - 1
            return
         .
      .
   .
   dig[] = [ ]
.
func next_highest n .
   while n > 0
      digs[] &= n mod 10
      n = n div 10
   .
   next_perm digs[]
   for i = len digs[] downto 1
      r = r * 10 + digs[i]
   .
   return r
.
nums[] = [ 0 9 12 21 12453 738440 45072010 95322020 ]
for n in nums[]
   print n & " -> " & next_highest n
.
