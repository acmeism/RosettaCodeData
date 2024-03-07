func f n x y .
   return (x + y * 2 + 1) mod n
.
numfmt 0 3
proc msqr n . .
   for i = 0 to n - 1
      for j = 0 to n - 1
         write f n (n - j - 1) i * n + f n j i + 1
      .
      print ""
   .
.
msqr 5
