t = 1580641200
print "First 15 palindrome dates after 2020-02-02 are:"
repeat
   t += 86400
   a$ = timestr t
   a$[] = strchars substr a$ 1 4 & substr a$ 6 2 & substr a$ 9 2
   for i = 1 to 4
      if a$[i] <> a$[9 - i]
         break 1
      .
   .
   if i = 5
      cnt += 1
      print substr a$ 1 10
   .
   until cnt = 15
.
