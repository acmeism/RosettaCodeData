fastfunc is_idoneal n .
   a = 1
   while a + 2 < n
      b = a + 1
      repeat
         ab = a * b
         sum = 0
         if ab < n
            c = (n - ab) div (a + b)
            sum = ab + c * (b + a)
            if c > b and sum = n : return 0
            b += 1
         .
         until sum > n or ab >= n
      .
      a += 1
   .
   return 1
.
while cnt < 65
   n += 1
   if is_idoneal n = 1
      cnt += 1
      write " " & n
   .
.
print ""
