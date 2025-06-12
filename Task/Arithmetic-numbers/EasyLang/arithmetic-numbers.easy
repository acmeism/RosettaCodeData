proc arith n &ari &comp .
   divi = 1
   repeat
      quot = n div divi
      until quot < divi
      if quot = divi and n mod divi = 0
         sum += quot
         divcnt += 1
         break 1
      .
      if n mod divi = 0
         sum += divi + quot
         divcnt += 2
      .
      divi += 1
   .
   ari = if sum mod divcnt = 0
   comp = if divcnt > 2
.
print "The first 100 arithmetic numbers are:"
n = 1
while cnt < 100
   arith n ari comp
   if ari = 1
      write n & " "
      cnt += 1
      compcnt += comp
   .
   n += 1
.
print ""
while cnt < 1e5
   arith n ari comp
   if ari = 1
      cnt += 1
      compcnt += comp
      if cnt = 1e3 or cnt = 1e4 or cnt = 1e5
         print ""
         print cnt & "th arithmetic number: " & n
         print "Composite arithmetic numbers: " & compcnt
      .
   .
   n += 1
.
