# stx$ = strchar 2
# etx$ = strchar 3
stx$ = "¹"
etx$ = "²"
#
proc sort &d$[] .
   for i = 2 to len d$[]
      h$ = d$[i]
      j = i - 1
      while j >= 1 and strcmp h$ d$[j] < 1
         d$[j + 1] = d$[j]
         j -= 1
      .
      d$[j + 1] = h$
   .
.
func$ bwt s$ .
   ss$ = stx$ & s$ & etx$
   for i to len ss$
      a$ = substr ss$ 1 i
      b$ = substr ss$ (i + 1) 9999
      tbl$[] &= b$ & a$
   .
   sort tbl$[]
   for s$ in tbl$[] : r$ &= substr s$ len s$ 1
   return r$
.
func$ ibwt r$ .
   le = len r$
   for i to le : tbl$[] &= ""
   for j to le
      for i to le
         tbl$[i] = substr r$ i 1 & tbl$[i]
      .
      sort tbl$[]
   .
   for row$ in tbl$[]
      if substr row$ le 1 = etx$
         return substr row$ 2 (le - 2)
      .
   .
.
for s$ in [ "banana" "appellee" "dogwood" "TO BE OR NOT TO BE OR WANT TO BE OR NOT?" "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES" ]
   print s$
   h$ = bwt s$
   print h$
   print ibwt h$
   print ""
.
