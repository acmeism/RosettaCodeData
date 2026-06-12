func bump n b .
   while n > 0
      d = n mod b
      if d > 0
         res += d * floor (pow (b + 1) bump i b + 0.5)
      .
      n = n div b
      i += 1
   .
   return res
.
func[] goodstein n maxterms .
   res[] = [ n ]
   while len res[] < maxterms and res[$] <> 0
      res[] &= bump res[$] (len res[] + 1) - 1
   .
   return res[]
.
for i = 0 to 7
   print goodstein i 10
.
print ""
for i = 0 to 10
   h[] = goodstein i (i + 1)
   print h[$]
.
