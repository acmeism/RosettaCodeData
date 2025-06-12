fastfunc square_free n .
   root = 2
   while root <= sqrt n
      if n mod (root * root) = 0 : return 0
      root += 1
   .
   return 1
.
proc run lo hi show .
   print "From " & lo & " to " & hi & ":"
   for i = lo to hi
      if square_free i = 1
         cnt += 1
         if show = 1 : write i & " "
      .
   .
   if show = 0 : write cnt & " numbers"
   print ""
   print ""
.
run 1 145 1
run 1000000000000 1000000000145 1
run 1 100 0
run 1 1000 0
run 1 10000 0
run 1 100000 0
run 1 1000000 0
