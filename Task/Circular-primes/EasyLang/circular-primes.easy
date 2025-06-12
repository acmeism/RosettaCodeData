fastfunc prime n .
   if n mod 2 = 0 and n > 2 : return 0
   i = 3
   while i <= sqrt n
      if n mod i = 0 : return 0
      i += 2
   .
   return 1
.
func cycle n .
   m = n
   p = 1
   while m >= 10
      p *= 10
      m = m div 10
   .
   return m + n mod p * 10
.
func circprime p .
   if prime p = 0 : return 0
   p2 = cycle p
   while p2 <> p
      if p2 < p or prime p2 = 0 : return 0
      p2 = cycle p2
   .
   return 1
.
p = 2
while count < 19
   if circprime p = 1
      write p & " "
      count += 1
   .
   p += 1
.
