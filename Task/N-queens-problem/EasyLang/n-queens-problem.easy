subr show_sol
   print "Solution " & n_sol
   print ""
   for i = 1 to n
      write "  "
      for j = 1 to n
         if j = x[i]
            write "Q "
         else
            write ". "
         .
      .
      print ""
   .
   print ""
.
subr test
   ok = 1
   for i = 1 to y - 1
      if x[y] = x[i] or abs (x[i] - x[y]) = abs (y - i)
         ok = 0
      .
   .
.
n = 8
len x[] n
y = 1
x[1] = 1
while y >= 1
   test
   if ok = 1 and y + 1 <= n
      y += 1
      x[y] = 1
   else
      if ok = 1
         n_sol += 1
         if n_sol <= 1
            show_sol
         .
      .
      while y >= 1 and x[y] = n
         y -= 1
      .
      if y >= 1
         x[y] += 1
      .
   .
.
print n_sol & " solutions"
