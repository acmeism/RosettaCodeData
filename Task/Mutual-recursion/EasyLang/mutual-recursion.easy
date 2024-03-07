funcdecl M n .
func F n .
   if n = 0
      return 1
   .
   return n - M F (n - 1)
.
func M n .
   if n = 0
      return 0
   .
   return n - F M (n - 1)
.
for i = 0 to 15
   write F i & " "
.
print ""
for i = 0 to 15
   write M i & " "
.
