fastfunc isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 1
   .
   return 1
.
fastfunc nextprim prim .
   repeat
      prim += 1
      until isprim prim = 1
   .
   return prim
.
proc insert &d[] e .
   for i = 1 to len d[]
      if d[i] >= e
         if d[i] = e : return
         break 1
      .
   .
   d[] &= 0
   for i = len d[] downto i + 1 : d[i] = d[i - 1]
   d[i] = e
.
proc fortunates .
   maxint = pow 2 53
   primorial = 1
   prim = 2
   repeat
      primorial *= prim
      until primorial + 1000 >= maxint
      prim = nextprim prim
      j = 3
      while isprim (primorial + j) = 0
         j = j + 2
      .
      insert fortuns[] j
   .
   for i to 8 : write fortuns[i] & " "
.
fortunates
