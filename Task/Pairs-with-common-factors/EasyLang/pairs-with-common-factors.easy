fastfunc isprim num .
   if i < 2 : return 0
   i = 2
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 1
   .
   return 1
.
func totient n .
   tot = n
   i = 2
   while i * i <= n
      if n mod i = 0
         repeat
            n /= i
            until n mod i <> 0
         .
         tot -= tot / i
      .
      if i = 2 : i = 1
      i += 2
   .
   if n > 1 : tot -= tot / n
   return tot
.
write "1-100:"
for n = 1 to 1000
   sumPhi += totient n
   if isprim n = 1
      a = ap
   else
      a = n * (n - 1) / 2 + 1 - sumPhi
   .
   if n <= 100 : write " " & a
   ap = a
.
print ""
print "1000: " & a
