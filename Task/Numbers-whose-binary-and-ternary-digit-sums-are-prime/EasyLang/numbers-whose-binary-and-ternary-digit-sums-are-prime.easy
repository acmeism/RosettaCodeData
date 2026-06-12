fastfunc isprim num .
   if num < 2 : return 0
   i = 2
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 1
   .
   return 1
.
func digsum n b .
   while n > 0
      sum += n mod b
      n = n div b
   .
   return sum
.
for i = 1 to 199
   if isprim digsum i 2 = 1 and isprim digsum i 3 = 1
      write i & " "
   .
.
print ""
