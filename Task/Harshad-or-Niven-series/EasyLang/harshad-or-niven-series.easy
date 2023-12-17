func digsum n .
   while n > 0
      sum += n mod 10
      n = n div 10
   .
   return sum
.
func isHarshad n .
   return if n mod digsum n = 0
.
i = 1
repeat
   if isHarshad i = 1
      write i & " "
      cnt += 1
   .
   until cnt = 20
   i += 1
.
print ""
i = 1001
while isHarshad i = 0
   i += 1
.
print i
