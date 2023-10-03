fastfunc sumprop num .
   if num = 1
      return 0
   .
   sum = 1
   root = sqrt num
   i = 2
   while i < root
      if num mod i = 0
         sum += i + num / i
      .
      i += 1
   .
   if num mod root = 0
      sum += root
   .
   return sum
.
func$ tostr ar[] .
   for v in ar[]
      s$ &= " " & v
   .
   return s$
.
func$ class k .
   oldk = k
   newk = sumprop oldk
   oldk = newk
   seq[] &= newk
   if newk = 0
      return "terminating " & tostr seq[]
   .
   if newk = k
      return "perfect " & tostr seq[]
   .
   newk = sumprop oldk
   oldk = newk
   seq[] &= newk
   if newk = 0
      return "terminating " & tostr seq[]
   .
   if newk = k
      return "amicable " & tostr seq[]
   .
   for t = 4 to 16
      newk = sumprop oldk
      seq[] &= newk
      if newk = 0
         return "terminating " & tostr seq[]
      .
      if newk = k
         return "sociable (period " & t - 1 & ") " & tostr seq[]
      .
      if newk = oldk
         return "aspiring " & tostr seq[]
      .
      for i to len seq[] - 1
         if newk = seq[i]
            return "cyclic (at " & newk & ") " & tostr seq[]
         .
      .
      if newk > 140737488355328
         return "non-terminating (term > 140737488355328) " & tostr seq[]
      .
      oldk = newk
   .
   return "non-terminating (after 16 terms)  " & tostr seq[]
.
print "Number classification sequence"
for j = 1 to 12
   print j & " " & class j
.
for j in [ 28 496 220 1184 12496 1264460 790 909 562 1064 1488 15355717786080 ]
   print j & " " & class j
.
