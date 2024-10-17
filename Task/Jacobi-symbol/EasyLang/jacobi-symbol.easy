func jacobi a n .
   a = a mod n
   res = 1
   while a <> 0
      while a mod 2 = 0
         a /= 2
         nn = n mod 8
         if nn = 3 or nn = 5
            res = -res
         .
      .
      swap a n
      if a mod 4 = 3 and n mod 4 = 3
         res = -res
      .
      a = a mod n
   .
   if n = 1
      return res
   .
   return 0
.
print " n/a  0  1  2  3  4  5  6  7  8  9"
print " ---------------------------------"
numfmt 2 3
for n = 1 step 2 to 17
   write n & " "
   for a = 0 to 9
      write jacobi a n
   .
   print ""
.
