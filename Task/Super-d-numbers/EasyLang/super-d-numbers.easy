proc bnmul &a[] b .
   for d in a[]
      h = c + d * b
      r[] &= h mod 10000000
      c = h div 10000000
   .
   if c > 0 : r[] &= c
   swap a[] r[]
.
func$ str bn[] .
   s$ = bn[$]
   for i = len bn[] - 1 downto 1
      h$ = bn[i]
      s$ &= substr "0000000" 1 (7 - len h$) & h$
   .
   return s$
.
func[] superd d .
   for i to d : dds = dds * 10 + d
   while len found[] < 10
      dnd[] = [ 1 ]
      for i to d : bnmul dnd[] n
      bnmul dnd[] d
      if strpos str dnd[] dds <> 0
         found[] &= n
      .
      n += 1
   .
   return found[]
.
for i = 2 to 6
   print i & ": " & strjoin superd i " "
.
