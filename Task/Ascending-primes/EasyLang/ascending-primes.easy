proc sort &d[] .
   for i = 1 to len d[] - 1 : for j = i + 1 to len d[]
      if d[j] < d[i] : swap d[j] d[i]
   .
.
func isprim num .
   if num < 2 : return 0
   i = 2
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 1
   .
   return 1
.
p[] = [ ]
proc nextasc n .
   if isprim n = 1 : p[] &= n
   if n > 123456789 : return
   for d = n mod 10 + 1 to 9
      nextasc n * 10 + d
   .
.
nextasc 0
sort p[]
print p[]
