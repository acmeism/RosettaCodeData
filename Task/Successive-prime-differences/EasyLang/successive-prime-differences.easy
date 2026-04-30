limit = 1000000
len sieve[] limit
fastproc mksieve .
   sieve[1] = 1
   maxs = sqrt len sieve[]
   for i = 2 to maxs : if sieve[i] = 0
      j = i * i
      while j <= len sieve[]
         sieve[j] = 1
         j += i
      .
   .
.
mksieve
fastfunc nextprime n .
   repeat
      n += 1
      if n > len sieve[] : return 0
      until sieve[n] = 0
   .
   return n
.
func isprim n .
   return 1 - sieve[n]
.
func spd n d[] .
   if isprim n = 0 : return 0
   for i = 1 to len d[]
      if nextprime n <> n + d[i] : return 0
      n += d[i]
   .
   return 1
.
proc print_set n d[] .
   write "( " & n & " "
   for i = 1 to len d[]
      write n + d[i] & " "
      n += d[i]
   .
   print ")"
.
proc show d[] .
   write "Differences of "
   for d in d[] : write d & " "
   print ""
   for n = 2 to limit - d[len d[]]
      if spd n d[] = 1
         c += 1
         if c = 1 : print_set n d[]
         last = n
      .
   .
   print_set last d[]
   print "Number of occurrences: " & c
   print ""
.
show [ 2 ]
show [ 1 ]
show [ 2 2 ]
show [ 2 4 ]
show [ 4 2 ]
show [ 6 4 2 ]
