proc bagchain curs$ n bc[] bs$[] start &outs$[] .
   if n = 0
      outs$[] &= curs$
      return
   .
   for i = start to len bs$[]
      c = bc[i]
      if c <= n
         bagchain (curs$ & bs$[i]) (n - c) bc[] bs$[] i outs$[]
      .
   .
.
func$[] bags_text n .
   if n = 0 : return [ "" ]
   for x = n - 1 downto 1
      tx$[] = bags_text x
      for i = 1 to len tx$[]
         bc[] &= x
         bs$[] &= tx$[i]
      .
   .
   bagchain "" (n - 1) bc[] bs$[] 1 core$[]
   for i = 1 to len core$[]
      res$[] &= "(" & core$[i] & ")"
   .
   return res$[]
.
for s$ in bags_text 5 : print s$
