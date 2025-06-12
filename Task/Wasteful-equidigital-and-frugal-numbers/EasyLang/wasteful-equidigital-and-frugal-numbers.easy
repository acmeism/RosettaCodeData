func ndig n .
   return log10 n div 1 + 1
.
len d[] 2000000
proc sieve .
   d[1] = 1
   for i = 2 to len d[]
      if d[i] = 0
         d[i] = ndig i
         j = i + i
         while j <= len d[]
            h = j
            e = 0
            while h mod i = 0
               h = h div i
               e += 1
            .
            h = 0
            if e > 1 : h = ndig e
            d[j] += ndig i + h
            j += i
         .
      .
   .
   for i to len d[]
      if d[i] > ndig i
         d[i] = 1
      elif d[i] = ndig i
         d[i] = 2
      else
         d[i] = 3
      .
   .
.
sieve
proc show t .
   i = 1
   repeat
      if d[i] = t
         cnt += 1
         if cnt <= 50 : write i & " "
      .
      until cnt = 10000
      i += 1
   .
   print ""
   print ""
   print i
   print ""
.
show 1
show 2
show 3
len sum[] 3
for i to 999999 : sum[d[i]] += 1
for h in sum[] : print h
