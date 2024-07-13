subr init
   symt$[] = strchars "abcdefghijklmnopqrstuvwxyz"
.
proc rot k . .
   c$ = symt$[k]
   for j = k downto 2
      symt$[j] = symt$[j - 1]
   .
   symt$[1] = c$
.
func[] encode s$ .
   init
   for c$ in strchars s$
      k = 1
      while symt$[k] <> c$
         k += 1
      .
      res[] &= k - 1
      rot k
   .
   return res[]
.
func$ decode s[] .
   init
   for k in s[]
      k += 1
      c$ = symt$[k]
      res$ &= c$
      rot k
   .
   return res$
.
for word$ in [ "broood" "babanaaa" "hiphophiphop" ]
   enc[] = encode word$
   print word$ & " -> " & enc[]
   if decode enc[] <> word$
      print "error"
   .
.
