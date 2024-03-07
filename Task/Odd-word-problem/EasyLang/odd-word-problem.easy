global inpi inp$ .
func$ read .
   inpi += 1
   return substr inp$ inpi 1
.
func ispunct c$ .
   if c$ = "." or c$ = ":" or c$ = ";" or c$ = ","
      return 1
   .
   return 0
.
func$ handle odd .
   c$ = read
   if ispunct c$ = 1
      return c$
   .
   if odd = 0
      write c$
      r$ = handle 0
      return r$
   else
      r$ = handle 1
      write c$
      return r$
   .
.
proc go . .
   repeat
      c$ = handle odd
      write c$
      until c$ = "."
      odd = 1 - odd
   .
   print ""
.
repeat
   inp$ = input
   until inp$ = ""
   inpi = 0
   go
.
input_data
we,are;not,in,kansas;any,more.
what,is,the;meaning,of:life.
