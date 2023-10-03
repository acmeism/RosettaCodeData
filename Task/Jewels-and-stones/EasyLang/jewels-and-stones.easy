func count stones$ jewels$ .
   len d[] 65536
   for c$ in strchars jewels$
      d[strcode c$] = 1
   .
   for c$ in strchars stones$
      if d[strcode c$] = 1
         cnt += 1
      .
   .
   return cnt
.
print count "aAAbbbb" "aA"
print count "ZZ" "z"
