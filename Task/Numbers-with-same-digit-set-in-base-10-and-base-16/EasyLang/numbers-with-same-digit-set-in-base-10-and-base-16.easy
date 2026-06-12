func digset n b .
   while n > 0
      h = bitshift 1 (n mod b)
      set = bitor set h
      n = n div b
   .
   return set
.
for i = 0 to 100000 - 1
   if digset i 10 = digset i 16
      write i & " "
   .
.
