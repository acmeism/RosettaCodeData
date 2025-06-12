fastfunc isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 1
   .
   return 1
.
proc primeSequ first last &sequ[] .
   for i = first to last
      if isprim i = 1 : sequ[] &= i
   .
.
primeSequ 2 100 seq[]
print seq[]
