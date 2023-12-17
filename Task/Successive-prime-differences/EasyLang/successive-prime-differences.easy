fastfunc isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 1
   .
   return 1
.
func nextprime n .
   n += 1
   while isprim n = 0
      n += 1
   .
   return n
.
func spd n d[] .
   if isprim n = 0
      return 0
   .
   for i = 1 to len d[]
      if nextprime n <> n + d[i]
         return 0
      .
      n += d[i]
   .
   return 1
.
proc print_set n d[] . .
   write "( " & n & " "
   for i = 1 to len d[]
      write n + d[i] & " "
      n += d[i]
   .
   print ")"
.
proc show max d[] . .
   write "Differences of "
   for d in d[]
      write d & " "
   .
   print ""
   for n = 2 to max - d[len d[]]
      if spd n d[] = 1
         c += 1
         if c = 1
            print_set n d[]
         .
         last = n
      .
   .
   print_set last d[]
   print "Number of occurrences: " & c
   print ""
.
show 1000000 [ 2 ]
show 1000000 [ 1 ]
show 1000000 [ 2 2 ]
show 1000000 [ 2 4 ]
show 1000000 [ 4 2 ]
show 1000000 [ 6 4 2 ]
