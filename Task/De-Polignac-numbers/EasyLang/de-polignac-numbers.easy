func isprim num .
   if num < 2 : return 0
   i = 2
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 1
   .
   return 1
.
n = 1
while count < 50
   j = 0
   repeat
      p = pow 2 j
      until p > n or isprim (n - p) = 1
      j += 1
   .
   if p > n
      count += 1
      write n & " "
   .
   n += 2
.

