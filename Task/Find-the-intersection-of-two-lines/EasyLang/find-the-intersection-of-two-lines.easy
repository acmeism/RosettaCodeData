func[] intersect ax1 ay1 ax2 ay2 bx1 by1 bx2 by2 .
   d = (by2 - by1) * (ax2 - ax1) - (bx2 - bx1) * (ay2 - ay1)
   if d = 0 : return [ 1 / 0 1 / 0 ]
   ua = ((bx2 - bx1) * (ay1 - by1) - (by2 - by1) * (ax1 - bx1)) / d
   ub = ((ax2 - ax1) * (ay1 - by1) - (by2 - by1) * (ax1 - bx1)) / d
   if abs ua > 1 or abs ub > 1 : return [ 1 / 0 1 / 0 ]
   return [ ax1 + ua * (ax2 - ax1) ay1 + ua * (ay2 - ay1) ]
.
print intersect 4 0 6 10 0 3 10 7
print intersect 4 0 6 10 0 3 10 7.1
print intersect 0 0 1 1 1 2 4 5
