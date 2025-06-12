fastfunc isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 1
   .
   return 1
.
func isunprim n .
   n$[] = strchars n
   for i to len n$[]
      s$ = n$[i]
      for d = 0 to 9
         n$[i] = d
         h = number strjoin n$[] ""
         if isprim h = 1 : return 0
      .
      n$[i] = s$
   .
   return 1
.
n = 1
while cnt < 35
   if isunprim n = 1
      write n & " "
      cnt += 1
   .
   n += 1
.
print ""
repeat
   if isunprim n = 1 : cnt += 1
   until cnt = 600
   n += 1
.
print n
