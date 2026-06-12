func steady n .
   mask = 1
   d = n
   while d > 0
      mask *= 10
      d = d div 10
   .
   return if n * n mod mask = n
.
for i = 1 to 9999
   if steady i = 1
      print i & " * " & i & " = " & i * i
   .
.
