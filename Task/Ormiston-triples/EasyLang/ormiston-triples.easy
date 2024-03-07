fastfunc isprim num .
   if num mod 3 = 0
      return 0
   .
   i = 5
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 2
      if num mod i = 0
         return 0
      .
      i += 4
   .
   return 1
.
func nextprim n .
   repeat
      n += 2
      until isprim n = 1
   .
   return n
.
func digs n .
   while n > 0
      r += pow 10 (n mod 10)
      n = n div 10
   .
   return r
.
print "Smallest member of the first 25 Ormiston triples:"
b = 2
a = 3
repeat
   c = b
   dc = db
   b = a
   db = da
   a = nextprim a
   until a > 1000000000
   da = digs a
   if da = db and da = dc
      cnt += 1
      if cnt <= 25
         write c & " "
      .
   .
.
print "Ormiston triples before 1 billion: " & cnt
