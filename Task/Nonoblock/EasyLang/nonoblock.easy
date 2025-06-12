func$ rep s$ n .
   for i to n : r$ &= s$
   return r$
.
func$[] genseq ones$[] nzeros .
   if len ones$[] = 0
      return [ rep "0" nzeros ]
   .
   for x = 1 to nzeros - len ones$[] + 1
      skip1$[] = [ ]
      for i = 2 to len ones$[]
         skip1$[] &= ones$[i]
      .
      h$[] = genseq skip1$[] (nzeros - x)
      for tail$ in h$[]
         r$[] &= rep "0" x & ones$[1] & tail$
      .
   .
   return r$[]
.
proc block data$ le .
   a[] = number strchars data$
   for b in a[] : nbytes += b
   print "blocks " & a[] & " cells " & le
   if le - nbytes <= 0
      print "No solution"
      return
   .
   for b in a[]
      prep$[] &= rep "1" b
   .
   for r$ in genseq prep$[] (le - nbytes + 1)
      print substr r$ 2 99999
   .
   print ""
.
block "21" 5
block "" 5
block "8" 10
block "2323" 15
block "23" 5
