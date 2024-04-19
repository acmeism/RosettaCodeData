fastfunc ispalin2 n .
   m = n
   while m > 0
      x = x * 2 + m mod 2
      m = m div 2
   .
   if n = x
      return 1
   .
.
fastfunc reverse3 n .
   while n > 0
      r = r * 3 + n mod 3
      n = n div 3
   .
   return r
.
func$ itoa n b .
   if n > 0
      return itoa (n div b) b & n mod b
   .
.
proc main . .
   print "0 0(2) 0(3)"
   print "1 1(2) 1(3)"
   pow3 = 3
   while 1 = 1
      for i = pow3 / 3 to pow3 - 1
         # assumption that the middle digit must be 1
         n = (i * 3 + 1) * pow3 + reverse3 i
         if ispalin2 n = 1
            print n & " " & itoa n 2 & "(2) " & itoa n 3 & "(3)"
            cnt += 1
            if cnt = 6 - 2
               return
            .
         .
      .
      pow3 *= 3
   .
.
main
