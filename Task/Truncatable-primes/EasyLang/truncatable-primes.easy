fastfunc isprim num .
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
func isright h .
   while h > 0
      if isprim h = 0
         return 0
      .
      h = h div 10
   .
   return 1
.
func isleft h .
   d = pow 10 (floor log10 h)
   while h > 0
      if isprim h = 0
         return 0
      .
      if h div d = 0
         return 0
      .
      h = h mod d
      d /= 10
   .
   return 1
.
p = 999999
while isleft p = 0
   p -= 2
.
print p
p = 999999
while isright p = 0
   p -= 2
.
print p
