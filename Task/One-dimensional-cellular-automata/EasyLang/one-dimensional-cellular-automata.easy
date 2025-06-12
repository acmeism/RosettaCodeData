map[] = [ 0 0 0 1 0 1 1 0 ]
cell[] = [ 0 1 1 1 0 1 1 0 1 0 1 0 1 0 1 0 0 1 0 0 ]
len celln[] len cell[]
proc evolve .
   for i = 2 to len cell[] - 1
      ind = cell[i - 1] + 2 * cell[i] + 4 * cell[i + 1] + 1
      celln[i] = map[ind]
   .
   swap celln[] cell[]
.
proc show .
   for v in cell[]
      if v = 1
         write "#"
      else
         write "."
      .
   .
   print ""
.
show
for i to 9
   evolve
   show
.
