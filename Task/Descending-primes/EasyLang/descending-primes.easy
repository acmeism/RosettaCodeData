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
proc nextdesc n . .
   if isprim n = 1
      write n & " "
   .
   if n > 987654321
      return
   .
   for d = n mod 10 - 1 downto 1
      nextdesc n * 10 + d
   .
.
for i = 9 downto 1
   nextdesc i
.
