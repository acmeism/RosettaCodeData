games$[] = [ "12" "13" "14" "23" "24" "34" ]
results$ = "000000"
#
proc sort &d[] .
   for i = 1 to len d[] - 1 : for j = i + 1 to len d[]
      if d[j] < d[i] : swap d[j] d[i]
   .
.
func tonum s$ b .
   for c$ in strchars s$ : r = r * b + number c$
   return r
.
func$ tostr ndig n b .
   for i to ndig
      d = n mod b
      n = n div b
      r$ = d & r$
   .
   return r$
.
func nextResult .
   if results$ = "222222" : return 0
   res = tonum results$ 3
   results$ = tostr 6 (res + 1) 3
   return 1
.
len points[][] 4
for i to 4 : len points[i][] 10
repeat
   results$[] = strchars results$
   records[] = [ 0 0 0 0 ]
   for i to 6
      if results$[i] = "2"
         records[strcode substr games$[i] 1 1 - 48] += 3
      elif results$[i] = "1"
         records[strcode substr games$[i] 1 1 - 48] += 1
         records[strcode substr games$[i] 2 1 - 48] += 1
      elif results$[i] = "0"
         records[strcode substr games$[i] 2 1 - 48] += 3
      .
   .
   sort records[]
   for i to 4 : points[i][records[i] + 1] += 1
   until nextResult = 0
.
print "POINTS       0   1   2   3   4   5   6   7   8   9"
print "--------------------------------------------------"
places$[] = [ "1st" "2nd" "3rd" "4th" ]
numfmt 4 0
for i to 4
   write places$[i] & " place "
   for j to 10 : write points[5 - i][j]
   print ""
.
