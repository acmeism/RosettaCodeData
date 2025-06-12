func gcd n d .
   if d = 0 : return n
   return gcd d (n mod d)
.
func totient n .
   for m = 1 to n
      if gcd m n = 1 : tot += 1
   .
   return tot
.
func isPowerful m .
   n = m
   f = 2
   l = sqrt m
   if m <= 1 : return 0
   while 1 = 1
      q = n div f
      if n mod f = 0
         if m mod (f * f) <> 0 : return 0
         n = q
         if f > n : return 1
      else
         f += 1
         if f > l
            if m mod (n * n) <> 0 : return 0
            return 1
         .
      .
   .
.
func isAchilles n .
   if isPowerful n = 0 : return 0
   m = 2
   a = m * m
   repeat
      repeat
         if a = n : return 0
         a *= m
         until a > n
      .
      m += 1
      a = m * m
      until a > n
   .
   return 1
.
print "First 50 Achilles numbers:"
n = 1
repeat
   if isAchilles n = 1
      write n & " "
      num += 1
   .
   n += 1
   until num >= 50
.
print ""
print ""
print "First 20 strong Achilles numbers:"
num = 0
n = 1
repeat
   if isAchilles n = 1 and isAchilles totient n = 1
      write n & " "
      num += 1
   .
   n += 1
   until num >= 20
.
print ""
print ""
print "Number of Achilles numbers with 2 to 5 digits:"
a = 10
b = 100
for i = 2 to 5
   num = 0
   for n = a to b - 1
      num += isAchilles n
   .
   write num & " "
   a = b
   b *= 10
.
