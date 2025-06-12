func divsum n alldiv .
   f = 2
   repeat
      q = n / f
      if n mod f = 0
         if alldiv = 1
            s1 += f
         else
            if f <> f0
               s1 += f
               f0 = f
            .
         .
         n = q
      else
         f += 1
      .
      until f > n
   .
   return s1
.
proc ruth_aaron alldiv .
   n = 2
   repeat
      s = divsum n alldiv
      if s = s0
         write n - 1 & " "
         c += 1
      .
      s0 = s
      n += 1
      until c >= 30
   .
.
print "first 30 ruth-aaron numbers (factors):"
ruth_aaron 1
print ""
print ""
print "first 30 ruth-aaron numbers (divisors):"
ruth_aaron 0
