len fact[] 12
arrbase fact[] 0
#
fact[0] = 1
for n = 1 to 11
   fact[n] = fact[n - 1] * n
.
for b = 9 to 12
   write "base " & b & " factorions:"
   for i = 1 to 1500000 - 1
      sum = 0
      j = i
      while j > 0
         d = j mod b
         sum += fact[d]
         j = j div b
      .
      if sum = i : write " " & i
   .
   print ""
.
