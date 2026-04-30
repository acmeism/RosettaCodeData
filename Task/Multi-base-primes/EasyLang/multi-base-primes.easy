len prim[][] 1679616 - 1
fastfunc isprim num .
   if num mod 2 = 0 and num > 2 : return 0
   i = 3
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 2
   .
   return 1
.
fastfunc tobase n b .
   while n > 0
      d = n mod b
      n = n div b
      r = r * 36 + d
      if r >= 1679616 : return 0
   .
   return r
.
for i = 2 to 1679616 - 1
   if isprim i = 1
      for b = 2 to 36
         h = tobase i b
         if h > 0 : prim[h][] &= b
      .
   .
.
func$ conv n .
   while n > 0
      d = n mod 36
      d$ = d
      if d >= 10 : d$ = strchar (87 + d)
      r$ &= d$
      n = n div 36
   .
   return r$
.
lim = 1
for digs = 1 to 4
   max = 0
   for i = lim to lim * 36 - 1
      if len prim[i][] > max
         max = len prim[i][]
      .
   .
   print digs & " digit(s)  max: " & max
   for i = lim to lim * 36 - 1
      if len prim[i][] = max
         print conv i & " " & prim[i][]
      .
   .
   lim *= 36
.
