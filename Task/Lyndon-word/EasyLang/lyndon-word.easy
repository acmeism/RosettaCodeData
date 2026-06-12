func$ nextword n w$ alpha$ .
   alpha$[] = strchars alpha$
   while len x$ < n
      x$ &= w$
   .
   x$[] = strchars substr x$ 1 n
   while len x$[] > 0 and x$[len x$[]] = alpha$[len alpha$[]]
      len x$[] -1
   .
   lx = len x$[]
   if lx > 0
      repeat
         i += 1
         until alpha$[i] = x$[lx]
      .
      x$[lx] = alpha$[i + 1]
   .
   return strjoin x$[] ""
.
proc lyndon n alpha$ .
   w$ = substr alpha$ 1 1
   while len w$ <= n and len w$ > 0
      print w$
      w$ = nextword n w$ alpha$
   .
.
lyndon 5 "01"
