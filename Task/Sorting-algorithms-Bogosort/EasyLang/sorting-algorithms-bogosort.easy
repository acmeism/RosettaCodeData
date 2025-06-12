proc shuffle &l[] .
   for i = len l[] downto 2
      r = random i
      swap l[i] l[r]
   .
.
func issorted &l[] .
   for i = 2 to len l[]
      if l[i] < l[i - 1] : return 0
   .
   return 1
.
proc bogosort &l[] .
   while issorted l[] = 0
      shuffle l[]
   .
.
list[] = [ 2 7 41 11 3 1 6 5 8 ]
bogosort list[]
print list[]
