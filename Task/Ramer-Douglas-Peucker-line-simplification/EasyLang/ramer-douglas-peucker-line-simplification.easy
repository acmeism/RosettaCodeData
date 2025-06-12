func perpdist px py p1x p1y p2x p2y .
   dx = p2x - p1x
   dy = p2y - p1y
   d = sqrt (dx * dx + dy * dy)
   return abs (px * dy - py * dx + p2x * p1y - p2y * p1x) / d
.
proc peucker eps &ptx[] &pty[] &outx[] &outy[] .
   n = len ptx[]
   idx = 1
   for i = 2 to n - 1
      dist = perpdist ptx[i] pty[i] ptx[1] pty[1] ptx[n] pty[n]
      if dist > dmax
         dmax = dist
         idx = i
      .
   .
   if dmax > eps
      for i to idx
         px[] &= ptx[i]
         py[] &= pty[i]
      .
      peucker eps px[] py[] outx[] outy[]
      #
      for i = idx to n
         p2x[] &= ptx[i]
         p2y[] &= pty[i]
      .
      peucker eps p2x[] p2y[] ox[] oy[]
      for i = 2 to len ox[]
         outx[] &= ox[i]
         outy[] &= oy[i]
      .
   else
      outx[] = [ ptx[1] ptx[n] ]
      outy[] = [ pty[1] pty[n] ]
   .
.
proc prpts px[] py[] .
   for i to len px[]
      write "(" & px[i] & " " & py[i] & ") "
   .
   print ""
.
px[] = [ 0 1 2 3 4 5 6 7 8 9 ]
py[] = [ 0 0.1 -0.1 5 6 7 8.1 9 9 9 ]
peucker 1 px[] py[] ox[] oy[]
prpts ox[] oy[]
