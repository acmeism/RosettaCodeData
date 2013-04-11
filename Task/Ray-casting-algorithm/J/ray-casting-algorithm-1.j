NB.*crossPnP v point in closed polygon, crossing number
NB.  bool=. points crossPnP polygon
crossPnP=: 4 : 0"2
  'X Y'=. |:x
  'x0 y0 x1 y1'=. |:2 ,/\^:(2={:@$@]) y
  p1=. ((y0<:/Y)*. y1>/Y) +. (y0>/Y)*. y1<:/Y
  p2=. (x0-/X) < (x0-x1) * (y0-/Y) % (y0 - y1)
  2|+/ p1*.p2
)
