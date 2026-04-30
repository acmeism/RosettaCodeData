bars$[] = strchars "▁▂▃▄▅▆▇█"
func$ sparkline a[] .
   for v in a[] : max = higher max v
   num = len bars$[]
   max += 1e-15 * max
   for v in a[]
      r$ &= bars$[floor (v / max * num) + 1]
   .
   return r$
.
proc show arr[] .
   print arr[]
   print sparkline arr[]
   print ""
.
show [ 1 2 3 4 5 6 7 8 7 6 5 4 3 2 1 ]
show [ 1.5 0.5 3.5 2.5 5.5 4.5 7.5 6.5 ]
show [ 0 1 19 20 ]
show [ 0 999 4000 4999 7000 7999 ]
