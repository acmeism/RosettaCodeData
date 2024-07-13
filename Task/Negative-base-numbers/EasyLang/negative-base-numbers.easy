func$ encode n b .
   if n = 0
      return "0"
   .
   while n <> 0
      r = n mod b
      n = n div b
      if r < 0
         n += 1
         r -= b
      .
      out$ = strchar (r + 48) & out$
   .
   return out$
.
func decode n$ b .
   if n$ = "0"
      return 0
   .
   for c$ in strchars n$
      c = strcode c$ - 48
      tot = tot * b + c
   .
   return tot
.
proc test n b . .
   h$ = encode n b
   print n & " -> " & h$ & "_" & b & " -> " & decode h$ b
.
test 10 -2
test 146 -3
test 15 -10
