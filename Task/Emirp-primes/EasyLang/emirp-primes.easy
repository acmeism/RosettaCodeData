fastfunc isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 1
   .
   return 1
.
func isemirp n .
   if isprim n = 0
      return 0
   .
   m = n
   while m > 0
      d = m mod 10
      m = m div 10
      rev = rev * 10 + d
   .
   if rev = n
      return 0
   .
   return isprim rev
.
m = 2
write "First 20 emirps: "
while cnt < 20
   if isemirp m = 1
      write m & " "
      cnt += 1
   .
   m += 1
.
print ""
write "Emirps between 7700 8000: "
for m = 7700 to 8000
   if isemirp m = 1
      write m & " "
   .
.
print ""
m = 2
cnt = 0
repeat
   cnt += isemirp m
   until cnt = 10000
   m += 1
.
print "The 10000th emirp: " & m
