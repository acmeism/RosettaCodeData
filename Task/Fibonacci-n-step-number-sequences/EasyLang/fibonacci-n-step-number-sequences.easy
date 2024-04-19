proc sequ n$ val[] n . .
   write n$ & ": "
   il = len val[]
   len val[] n
   for i = il + 1 to n
      for j = 1 to il
         val[i] += val[i - j]
      .
   .
   for v in val[]
      write v & " "
   .
   print ""
.
sequ "Fibonacci" [ 1 1 ] 10
sequ "Tribonacci" [ 1 1 2 ] 10
sequ "Tetrabonacci" [ 1 1 2 4 ] 10
sequ "Lucas" [ 2 1 ] 10
