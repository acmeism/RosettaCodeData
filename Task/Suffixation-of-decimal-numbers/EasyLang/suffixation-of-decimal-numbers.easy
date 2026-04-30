func$ strip s$ r$ .
   for c$ in strchars s$
      if c$ <> r$ : out$ &= c$
   .
   return out$
.
func$ tofixed x d .
   if d <= 0
      y = floor (x + 0.5)
      return y
   .
   scale = pow 10 d
   y = floor (x * scale + 0.5)
   int = y div scale
   frac = y - int * scale
   f$ = abs frac
   while len f$ < d : f$ = "0" & f$
   return int & "." & f$
.
func$ rstrip0 s$ .
   while len s$ > 0 and substr s$ len s$ 1 = "0" : s$ = substr s$ 1 (len s$ - 1)
   if len s$ > 0 and substr s$ (len s$) 1 = "." : s$ = substr s$ 1 (len s$ - 1)
   return s$
.
sfx$[] = [ "" "K" "M" "G" "T" "P" "E" "Z" "Y" "X" "W" "V" "U" "googol" ]
func$ suffize num$ digits base .
   if base = 0 : base = 10
   expdist = 3
   if base = 2 : expdist = 10
   num$ = strip num$ ","
   c$ = substr num$ 1 1
   if c$ = "+" or c$ = "-" : sgn$ = c$
   num = abs number num$
   if error <> 0 : num = 0
   if base = 10 and num >= 1e100
      sidx = 13
      num /= 1e100
   elif num > 1
      mag = floor log num base
      sidx = lower floor (mag / expdist) 12
      num /= pow base (expdist * sidx)
   .
   sidx += 1
   if digits <> -1
      nstr$ = tofixed num digits
   else
      nstr$ = rstrip0 tofixed num 3
   .
   out$ = sgn$ & nstr$ & sfx$[sidx]
   if base = 2 : out$ &= "i"
   return out$
.
print "87,654,321 : " & suffize "87,654,321", -1, 10
print "-998,877,665,544,332,211,000 3 : " & suffize "-998,877,665,544,332,211,000", 3, 10
print "+112,233 0 : " & suffize "+112,233", 0, 10
print "16,777,216 1 : " & suffize "16,777,216", 1, 10
print "456,789,100,000,000 2 : " & suffize "456,789,100,000,000", 2, 10
print "456,789,100,000,000 5 base:2 : " & suffize "456,789,100,000,000", 5, 2
print "456,789,100,000.000e+00 0 : " & suffize "456,789,100,000.000e+00", 0, 10
print "+16777216 base:2 : " & suffize "+16777216", -1, 2
print "1.2e101 : " & suffize "1.2e101", -1, 10
