moves[][] = [ [ -1 0 ] [ 0 -1 ] [ 0 1 ] [ 1 0 ] ]
global brd[][] maxr maxc maxcnt .
func solve r c cnt .
   if cnt > maxcnt : return 1
   for m = 1 to 4
      rn = r + moves[m][1]
      cn = c + moves[m][2]
      if rn >= 1 and rn <= maxr and cn >= 1 and cn <= maxc
         if brd[rn][cn] = 0
            brd[rn][cn] = cnt
            if solve rn cn (cnt + 1) = 1 : return 1
            brd[rn][cn] = 0
         elif brd[rn][cn] = cnt
            if solve rn cn (cnt + 1) = 1 : return 1
         .
      .
   .
   return 0
.
proc prepare brd$ &r0 &c0 .
   brd$[] = strsplit brd$ "\n"
   maxc = len brd$[2] / 3
   maxr = len brd$[] - 2
   maxcnt = maxc * maxr
   len brd[][] maxr
   for r to maxr
      len brd[r][] maxc
      for c to maxc
         c$ = substr brd$[r + 1] (c * 3 - 2) 3
         h = number c$
         if h = 1
            r0 = r
            c0 = c
         .
         brd[r][c] = h
      .
   .
.
proc printbrd .
   numfmt 3 0
   for r to maxr
      for c to maxc : write brd[r][c]
      print ""
   .
.
proc numbrix brd$ .
   prepare brd$ r0 c0
   if solve r0 c0 2 = 1
      printbrd
   else
      print "no solutions found"
   .
   print ""
.
numbrix "
  0  0  0  0  0  0  0  0  0
  0  0 46 45  0 55 74  0  0
  0 38  0  0 43  0  0 78  0
  0 35  0  0  0  0  0 71  0
  0  0 33  0  0  0 59  0  0
  0 17  0  0  0  0  0 67  0
  0 18  0  0 11  0  0 64  0
  0  0 24 21  0  1  2  0  0
  0  0  0  0  0  0  0  0  0
"
numbrix "
  0  0  0  0  0  0  0  0  0
  0 11 12 15 18 21 62 61  0
  0  6  0  0  0  0  0 60  0
  0 33  0  0  0  0  0 57  0
  0 32  0  0  0  0  0 56  0
  0 37  0  1  0  0  0 73  0
  0 38  0  0  0  0  0 72  0
  0 43 44 47 48 51 76 77  0
  0  0  0  0  0  0  0  0  0
"
