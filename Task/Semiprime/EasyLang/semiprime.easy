fastfunc factor num .
   i = 2
   while i <= sqrt num
      if num mod i = 0
         return i
      .
      i += 1
   .
   return 1
.
func semiprime n .
   f1 = factor n
   if f1 = 1
      return 0
   .
   f2 = n div f1
   if factor f1 = 1 and factor f2 = 1
      return 1
   .
   return 0
.
for i = 1 to 1000
   if semiprime i = 1
      write i & " "
   .
.
