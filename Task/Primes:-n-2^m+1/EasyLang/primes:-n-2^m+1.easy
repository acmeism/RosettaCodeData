func isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 1
   .
   return 1
.
for n = 1 to 45
   m = 0
   repeat
      p = n * (pow 2 m) + 1
      until isprim p = 1
      m += 1
   .
   write "(" & n & " " & m & " " & p & ") "
.
print ""
