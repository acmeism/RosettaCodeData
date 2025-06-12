proc mkfibs n &fib[] .
   fib[] = [ ]
   last = 1
   current = 1
   while current <= n
      fib[] &= current
      nxt = last + current
      last = current
      current = nxt
   .
.
func$ zeckendorf n .
   mkfibs n fib[]
   for pos = len fib[] downto 1
      if n >= fib[pos]
         zeck$ &= "1"
         n -= fib[pos]
      else
         zeck$ &= "0"
      .
   .
   if zeck$ = "" : return "0"
   return zeck$
.
for n = 0 to 20
   print " " & n & " " & zeckendorf n
.
