func[] coefs n .
   list[] = [ 1 ]
   arrbase list[] 0
   for k = 0 to n : list[] &= list[k] * (n - k) / (k + 1)
   for k = 1 step 2 to n : list[k] = -list[k]
   return list[]
.
func isprimeaks n .
   c[] = coefs n
   c[0] -= 1
   c[n] += 1
   for i = 0 to n
      if c[i] mod n <> 0 : return 0
   .
   return 1
.
proc pprintcoefs n list[] .
   for i = 0 to n
      s$ = ""
      if i > 0
         s$ = " + "
         if list[i] < 0 : s$ = " - "
      .
      c$ = abs list[i]
      e = n - i
      if c$ = "1" and e > 0 : c$ = ""
      x$ = ""
      if e <> 0
         x$ = "x"
         if e <> 1 : x$ &= "^" & e
      .
      r$ &= s$ & c$ & x$
   .
   print "(x-1)^" & n & " : " & r$
.
for i = 0 to 7
   pprintcoefs i coefs i
.
print ""
for i = 2 to 49
   if isprimeaks i = 1 : write i & " "
.
print ""
