fastfunc isprim num .
   if num <= 1 : return 0
   if num mod 2 = 0 and num > 2 : return 0
   i = 3
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 2
   .
   return 1
.
func test1 s .
   for a = 2 to s div 2
      if isprim a = 1 and isprim (s - a) = 1 : return 0
   .
   return 1
.
func test2 p .
   for i = 2 to sqrt p
      if p mod i = 0
         j = p / i
         if j >= 2 and j <= 99 and test1 (i + j) = 1
            if winner = 1 : return 0
            winner = 1
         .
      .
   .
   return winner
.
func test3 s .
   if test1 s = 0 : return 0
   for a = 2 to s div 2
      b = s - a
      if test2 (a * b) = 1
         if winner <> 0 : return 0
         winner = a
      .
   .
   return winner
.
for s = 2 to 100
   a = test3 s
   if a <> 0
      print s & " (" & a & "+" & s - a & ")"
   .
.
