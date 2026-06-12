func has9 v .
   while v > 0
      if v mod 10 = 9
         return 1
      .
      v = v div 10
   .
   return 0
.
ones = 1
pow10 = 10
while count < 5
   while n * n > pow10
      pow10 *= 10
      ones = ones * 10 + 1
   .
   if has9 (n * n) = 0
      sq = n * n + ones
      if sqrt sq mod 1 = 0
         write " " & sq
         count += 1
      .
   .
   n += 1
.
