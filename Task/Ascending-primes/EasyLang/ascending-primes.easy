func isprim num .
   if num < 2
      return 0
   .
   i = 2
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 1
   .
   return 1
.
proc nextasc n . .
   if isprim n = 1
      write n & " "
   .
   if n > 123456789
      return
   .
   for d = n mod 10 + 1 to 9
      nextasc n * 10 + d
   .
.
nextasc 0
