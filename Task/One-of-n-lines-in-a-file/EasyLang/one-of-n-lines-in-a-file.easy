n = 10
trials = 1000000
func one n .
   for i = 1 to n
      if randomf < 1 / i
         chosen = i
      .
   .
   return chosen
.
len results[] n
for i = 1 to trials
   r = one n
   results[r] += 1
.
print "Value   Occurrences"
print "-------------------"
for i to n
   print i & "\t" & results[i]
.
