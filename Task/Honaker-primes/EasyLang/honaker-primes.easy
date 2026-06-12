fastfunc nextprim num .
   repeat
      i = 2
      while i <= sqrt num and num mod i <> 0
         i += 1
      .
      until num mod i <> 0
      num += 1
   .
   return num
.
func digsum n .
   while n > 0
      sum += n mod 10
      n = n div 10
   .
   return sum
.
proc show .
   i = 1
   pri = 2
   while count < 50
      if digsum i = digsum pri
         write "(" & i & " " & pri & ") "
         count += 1
      .
      i += 1
      pri = nextprim (pri + 1)
   .
.
show
