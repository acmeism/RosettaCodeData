lists[][] = [ [ 9 3 3 3 2 1 7 8 5 ] [ 5 2 9 3 3 7 8 4 1 ] [ 1 4 3 6 7 3 8 3 2 ] [ 1 2 3 4 5 6 7 8 9 ] [ 4 6 8 7 2 3 3 3 1 ] ]
func has3adj3 l[] .
   for v in l[]
      if v = 3
         cnt += 1
      else
         if cnt = 3 : break 1
         cnt = 0
      .
   .
   return if cnt = 3
.
for i to len lists[][]
   write has3adj3 lists[i][] & " "
.
print ""
