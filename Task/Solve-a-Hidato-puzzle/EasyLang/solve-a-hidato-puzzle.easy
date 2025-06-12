moves[][] = [ [ -1 -1 ] [ -1 0 ] [ -1 1 ] [ 0 -1 ] [ 0 1 ] [ 1 -1 ] [ 1 0 ] [ 1 1 ] ]
global brd[][] maxr maxc maxcnt ancor .
func solve r c cnt .
   if cnt - ancor > 13 : return 0
   if cnt > maxcnt : return 1
   for m = 1 to len moves[][]
      rn = r + moves[m][1]
      cn = c + moves[m][2]
      if rn >= 1 and rn <= maxr and cn >= 1 and cn <= maxc
         if brd[rn][cn] = 0
            brd[rn][cn] = cnt
            if solve rn cn (cnt + 1) = 1 : return 1
            brd[rn][cn] = 0
         elif brd[rn][cn] = cnt
            oldanc = ancor
            ancor = cnt
            if solve rn cn (cnt + 1) = 1 : return 1
            ancor = oldanc
         .
      .
   .
   return 0
.
brd$ = "
 __ 33 35 __ __  .  .  .
 __ __ 24 22 __  .  .  .
 __ __ __ 21 __ __  .  .
 __ 26 __ 13 40 11  .  .
 27 __ __ __  9 __  1  .
  .  . __ __ 18 __ __  .
  .  .  .  . __  7 __ __
  .  .  .  .  .  .  5 __
"
proc prepare &r0 &c0 .
   brd$[] = strsplit brd$ "\n"
   maxc = len brd$[2] / 3
   maxr = len brd$[] - 2
   len brd[][] maxr
   for r to maxr
      for c to maxc
         c$ = substr brd$[r + 1] (c * 3 - 2) 3
         if c$ = "  ."
            h = -1
         elif c$ = " __"
            h = 0
         else
            h = number c$
            maxcnt = higher maxcnt h
            if h = 1
               r0 = r
               c0 = c
            .
         .
         brd[r][] &= h
      .
   .
   ancor = 1
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
if solve r0 c0 2 = 1
   printbrd
else
   print "no solutions found"
.
