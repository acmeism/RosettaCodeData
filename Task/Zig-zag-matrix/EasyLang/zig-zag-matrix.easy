func sumto n .
   return n * (n + 1) div 2
.
func coord2num row col n .
   diag = col + row
   if diag < n
      start = sumto diag
      if diag mod 2 = 0
         offs = col
      else
         offs = row
      .
   else
      start = n * n - sumto (2 * n - 1 - diag)
      offs = n - 1
      if diag mod 2 = 0
         offs -= row
      else
         offs -= col
      .
   .
   return start + offs
.
n = 6
numfmt 3 0
for row = 0 to n - 1
   for col = 0 to n - 1
      write coord2num row col n
   .
   print ""
.
