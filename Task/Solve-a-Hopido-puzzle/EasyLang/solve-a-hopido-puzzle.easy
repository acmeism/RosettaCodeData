brd$ = "
.##.##.
#######
#######
.#####.
..###..
...#...
"
moves[][] = [ [ -3 0 ] [ 0 3 ] [ 3 0 ] [ 0 -3 ] [ 2 2 ] [ 2 -2 ] [ -2 2 ] [ -2 -2 ] ]
global brd[][] maxr maxc maxcnt .
func solve r c cnt .
   if cnt > maxcnt : return 1
   for m = 1 to len moves[][]
      rn = r + moves[m][1]
      cn = c + moves[m][2]
      if rn >= 1 and rn <= maxr and cn >= 1 and cn <= maxc and brd[rn][cn] = 0
         brd[rn][cn] = cnt
         if solve rn cn (cnt + 1) = 1 : return 1
         brd[rn][cn] = 0
      .
   .
   return 0
.
proc prepare &r0 &c0 .
   brd$[] = strsplit brd$ "\n"
   maxc = len brd$[2]
   maxr = len brd$[] - 2
   len brd[][] maxr
   for r to maxr
      for c to maxc
         h = if substr brd$[r + 1] c 1 = "#"
         maxcnt += h
         brd[r][] &= h - 1
         if h = 1 and r0 = 0
            r0 = r
            c0 = c
         .
      .
   .
.
proc printbrd .
   numfmt 3 0
   for r to maxr
      for c to maxc
         if brd[r][c] = -1
            write "   "
         else
            write brd[r][c]
         .
      .
      print ""
   .
.
prepare r0 c0
brd[r0][c0] = 1
if solve r0 c0 2 = 1
   printbrd
else
   print "no solutions found"
.
