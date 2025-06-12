func isprim n .
   if n mod 2 = 0 and n > 2 : return 0
   i = 3
   sq = sqrt n
   while i <= sq
      if n mod i = 0 : return 0
      i += 2
   .
   return 1
.
func goldbach n .
   for i = 2 to n div 2
      if isprim i = 1 : cnt += isprim (n - i)
   .
   return cnt
.
numfmt 3 0
for n = 4 step 2 to 202
   write goldbach n
   if n mod 20 = 2 : print ""
.
print goldbach 1000000
