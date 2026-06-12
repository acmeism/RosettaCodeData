func isprim n .
   i = 3
   while i <= sqrt n
      if n mod i = 0 : return 0
      i += 2
   .
   return 1
.
for n = 3 step 2 to 991
   if isprim n = 1 and isprim (n + 2) = 1 and isprim (n + 6) = 1 and isprim (n + 8) = 1
      print "(" & n & " " & n + 2 & " " & n + 6 & " " & n + 8 & ") "
   .
.
