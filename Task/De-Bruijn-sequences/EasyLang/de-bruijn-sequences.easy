global a[] seq[] k n .
proc db t p . .
   if t > n
      if n mod p = 0
         for i = 1 to p
            seq[] &= a[i + 1]
         .
      .
   else
      a[t + 1] = a[t - p + 1]
      db t + 1 p
      j = a[t - p + 1] + 1
      while j < k
         a[t + 1] = j mod 256
         db t + 1 t
         j += 1
      .
   .
.
func$ debruijn k0 n0 .
   k = k0
   n = n0
   a[] = [ ]
   len a[] k * n
   seq[] = [ ]
   db 1 1
   for v in seq[]
      buf$ &= v
   .
   buf$ &= substr buf$ 1 (n - 1)
   return buf$
.
func alldigits s$ .
   for c$ in strchars s$
      if strcode c$ < 48 or strcode c$ > 57
         return 0
      .
   .
   return 1
.
proc validate db$ . .
   len found[] 10000
   for i = 1 to len db$ - 3
      s$ = substr db$ i 4
      if alldigits s$ = 1
         n = number s$
         found[n + 1] += 1
      .
   .
   for i = 1 to 10000
      if found[i] = 0
         errs$[] &= "    PIN number " & i - 1 & " missing"
      elif found[i] > 1
         errs$[] &= "    PIN number " & i - 1 & " occurs " & found[i] & " times"
      .
   .
   if len errs$[] = 0
      print "  No errors found"
   else
      for s$ in errs$[]
         print s$
      .
   .
.
proc main . .
   db$ = debruijn 10 4
   print "The length of the de Bruijn sequence is " & len db$
   print ""
   write "The first 130 digits of the de Bruijn sequence are: "
   print substr db$ 1 130
   print ""
   write "The last 130 digits of the de Bruijn sequence are: "
   print substr db$ -130 130
   print ""
   print "Validating the de Bruijn sequence:"
   validate db$
   print ""
   print "Validating the reversed de Bruijn sequence:"
   for i = len db$ downto 1
      dbr$ &= substr db$ i 1
   .
   validate dbr$
   print ""
   db$ = substr db$ 1 4443 & "." & substr db$ 4445 (1 / 0)
   print "Validating the overlaid de Bruijn sequence:"
   validate db$
   print ""
.
main
