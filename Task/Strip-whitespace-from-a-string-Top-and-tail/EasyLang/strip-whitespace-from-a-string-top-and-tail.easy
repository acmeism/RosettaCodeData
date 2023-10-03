func iswhite c$ .
   if c$ = " " or c$ = "\t" or c$ = "\n"
      return 1
   .
.
func$ strip s$ top tail .
   a = 1
   if top = 1
      repeat
         c$ = substr s$ a 1
         until iswhite c$ = 0
         a += 1
      .
   .
   b = len s$
   if tail = 1
      repeat
         c$ = substr s$ b 1
         until iswhite c$ = 0
         b -= 1
      .
   .
   return substr s$ a (b - a + 1)
.
print strip "    Hello world   " 1 1 & "."
print strip "    Hello world   " 0 1 & "."
print strip "    Hello world   " 1 1 & "."
