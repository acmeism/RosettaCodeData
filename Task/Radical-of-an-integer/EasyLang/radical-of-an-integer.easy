fastfunc radnf num .
   d = 2
   while d <= sqrt num
      if num mod d = 0
         nf += 1
         while num mod d = 0
            num /= d
         .
      .
      d += 1
   .
   if d <= num : nf += 1
   return nf
.
func rad num .
   r = 1
   d = 2
   while d <= sqrt num
      if num mod d = 0
         r *= d
         while num mod d = 0
            num /= d
         .
      .
      d += 1
   .
   if d <= num : r *= num
   return r
.
proc show50 .
   write "First 50 radicals:"
   for n = 1 to 50
      write " " & rad n
   .
   print ""
.
proc show n .
   print "radical(" & n & ") = " & rad n
.
proc dist .
   len dist[] 7
   for n = 2 to 1000000
      dist[radnf n] += 1
   .
   print ""
   print "Distribution of radicals:"
   print "0: 1"
   for i = 1 to 7
      print i & ": " & dist[i]
   .
.
show50
print ""
show 99999
show 499999
show 999999
print ""
dist
