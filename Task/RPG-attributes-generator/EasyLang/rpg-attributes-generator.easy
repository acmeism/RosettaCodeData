func rollstat .
   for i to 4
      h = randint 6
      s += h
      min = lower min h
   .
   return s - min
.
state$[] = [ "STR" "CON" "DEX" "INT" "WIS" "CHA" ]
len stat[] 6
repeat
   sum = 0
   n15 = 0
   for i to 6
      stat[i] = rollstat
      sum += stat[i]
      if stat[i] >= 15
         n15 += 1
      .
   .
   until sum >= 75 and n15 >= 2
.
for i to 6
   print state$[i] & ": " & stat[i]
.
print "-------"
print "TOT: " & sum
