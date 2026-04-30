func[] StandardRank d[] .
   for i to len d[]
      if i = 1 or d[i] <> d[i - 1] : k = i
      r[] &= k
   .
   return r[]
.
func[] ModifiedRank d[] .
   for i to len d[]
      k = i
      j = i + 1
      while j <= len d[] and d[i] = d[j]
         k = j
         j += 1
      .
      r[] &= k
   .
   return r[]
.
func[] DenseRank d[] .
   for i to len d[]
      if i = 1 or d[i] <> d[i - 1] : k += 1
      r[] &= k
   .
   return r[]
.
func[] OrdinalRank d[] .
   for i to len d[] : r[] &= i
   return r[]
.
func[] FractionalRank d[] .
   i = 1
   while i <= len d[]
      f = i
      j = i + 1
      while j <= len d[] and d[i] = d[j]
         f += j
         j += 1
      .
      f /= (j - i)
      while i < j
         r[] &= f
         i += 1
      .
   .
   return r[]
.
data[] = [ 44 42 42 41 41 41 39 ]
names$[] = [ "Solomon" "Jason" "Errol" "Garry" "Bernard" "Barry" "Stephen" ]
#
proc show name$ r[] .
   print name$ & " Ranking"
   for i to len names$[]
      print "  " & r[i] & " - " & data[i] & " " & names$[i]
   .
   print ""
.
show "Standard" StandardRank data[]
show "Modified" ModifiedRank data[]
show "Dense" DenseRank data[]
show "Ordinal" OrdinalRank data[]
show "Fractional" FractionalRank data[]
