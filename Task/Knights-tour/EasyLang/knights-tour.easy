sys topleft
dirs[][] = [ [ 1 2 ] [ 1 -2 ] [ 2 1 ] [ 2 -1 ] [ -1 2 ] [ -1 -2 ] [ -2 -1 ] [ -2 1 ] ]
global brd[][] size .
func cntmoves m[] .
   for d = 1 to len dirs[][]
      rn = m[1] + dirs[d][1]
      cn = m[2] + dirs[d][2]
      if rn >= 1 and rn <= size and cn >= 1 and cn <= size and brd[rn][cn] = 0
         n += 1
      .
   .
   return n
.
proc sortmoves &m[][] .
   for i = 1 to len m[][]
      cnt[] &= cntmoves m[i][]
   .
   for i = 1 to len cnt[] - 1 : for j = i + 1 to len cnt[]
      if cnt[j] < cnt[i]
         swap cnt[j] cnt[i]
         swap m[j][] m[i][]
      .
   .
.
func solve r c cnt .
   if cnt > size * size : return 1
   movs[][] = [ ]
   for d = 1 to len dirs[][]
      rn = r + dirs[d][1]
      cn = c + dirs[d][2]
      if rn >= 1 and rn <= size and cn >= 1 and cn <= size and brd[rn][cn] = 0
         movs[][] &= [ rn cn ]
      .
   .
   sortmoves movs[][]
   for i = 1 to len movs[][]
      rn = movs[i][1]
      cn = movs[i][2]
      brd[rn][cn] = cnt
      if solve rn cn (cnt + 1) = 1 : return 1
      brd[rn][cn] = 0
   .
   return 0
.
proc prepare .
   brd[][] = [ ]
   len brd[][] size
   for r to size : len brd[r][] size
.
proc printbrd .
   numfmt 3 0
   if size > 10 : numfmt 4 0
   for r to size
      for c to size : write brd[r][c]
      print ""
   .
.
size = 8
r0 = random size
c0 = random size
prepare
brd[r0][c0] = 1
found = solve r0 c0 2
if found = 1
   printbrd
   print ""
else
   print "no solutions found: (" & r0 & " " & c0 & ")"
.
#
proc showgraf .
   sc = 100 / size
   glinewidth sc / 15
   col[] = [ 777 333 ]
   for r = 0 to size - 1 : for c = 0 to size - 1
      gcolor col[(r + c) mod1 2]
      grect sc * c sc * r sc sc
   .
   for i to size * size
      for r = 1 to size : for c = 1 to size : if brd[r][c] = i
         gcolor 600
         x = c * sc - sc / 2
         y = r * sc - sc / 2
         if i > 1 : gline xp yp x y
         xp = x
         yp = y
         gcolor 880
         gcircle x y sc / 10
      .
   .
.
if found = 1 : showgraf
