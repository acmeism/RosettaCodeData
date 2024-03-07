func isin t$ .
   if len t$ <> 12
      return 0
   .
   for i to 12
      k = strcode substr t$ i 1
      if k >= 48 and k <= 57
         if i <= 2
            return 0
         .
         s[] &= k - 48
      elif k >= 65 and k <= 91
         if (i = 12)
            return 0
         .
         k -= 55
         s[] &= k div 10
         s[] &= k mod 10
      else
         return 0
      .
   .
   i = len s[] - 1
   while i >= 1
      k = 2 * s[i]
      if k > 9
         k -= 9
      .
      v += k
      i -= 2
   .
   i = len s[]
   while i >= 1
      v += s[i]
      i -= 2
   .
   if v mod 10 = 0
      return 1
   .
.
test$[] = [ "US0378331005" "US0373831005" "U50378331005" "US03378331005" "AU0000XVGZA3" "AU0000VXGZA3" "FR0000988040" ]
for t$ in test$[]
   if isin t$ = 1
      print t$ & " is valid"
   else
      print t$ & " is invalid"
   .
.
