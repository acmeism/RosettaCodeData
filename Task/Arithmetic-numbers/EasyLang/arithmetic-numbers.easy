print "The first 100 arithmetic numbers are:"
numfmt 0 3
n = 1
while aricnt <= 1e5
   divi = 1 ; divcnt = 0 ; sum = 0
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
   if sum mod divcnt = 0
      aricnt += 1
      if aricnt <= 100
         write n & " "
         if aricnt mod 10 = 0
            print ""
         .
      .
      if divcnt > 2
         compcnt += 1
      .
      if aricnt = 1e3 or aricnt = 1e4 or aricnt = 1e5
         print ""
         print aricnt & "th arithmetic number: " & n
         print "Composite arithmetic numbers: " & compcnt
      .
   .
   n += 1
.
