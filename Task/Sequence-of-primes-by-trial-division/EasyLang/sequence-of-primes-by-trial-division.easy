func prime n .
   if n mod 2 = 0 and n > 2
      return 0
   .
   i = 3
   while i <= sqrt n
      if n mod i = 0
         return 0
      .
      i += 2
   .
   return 1
.
proc primeSequ first last . sequ[] .
   for i = first to last
      if prime i = 1
         sequ[] &= i
      .
   .
.
primeSequ 2 100 seq[]
print seq[]
