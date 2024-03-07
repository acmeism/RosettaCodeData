proc shuffle . l[] .
   for i = len l[] downto 2
      r = randint i
      swap l[i] l[r]
   .
.
proc issorted . l[] r .
   for i = 2 to len l[]
      if l[i] < l[i - 1]
         r = 0
         return
      .
   .
   r = 1
.
proc bogosort . l[] .
   repeat
      issorted l[] r
      until r = 1
      shuffle l[]
   .
.
list[] = [ 2 7 41 11 3 1 6 5 8 ]
bogosort list[]
print list[]
