func has8divs n .
   if n = 1
      return 1
   .
   cnt = 2
   sqr = sqrt n
   for d = 2 to sqr
      if n mod d = 0
         cnt += 1
         if d <> sqr
            cnt += 1
         .
         if cnt > 8
            return 0
         .
      .
   .
   if cnt = 8
      return 1
   .
   return 0
.
while count < 50
   x += 1
   if has8divs x = 1
      write x & " "
      count += 1
   .
.
while count < 50000
   x += 1
   if has8divs x = 1
      count += 1
      if count = 500 or count = 5000 or count = 50000
         print count & "th: " & x
      .
   .
.
