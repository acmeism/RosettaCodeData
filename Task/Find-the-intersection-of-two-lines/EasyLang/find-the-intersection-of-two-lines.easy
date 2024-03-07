proc intersect ax1 ay1 ax2 ay2 bx1 by1 bx2 by2 . rx ry .
   rx = 1 / 0
   ry = 1 / 0
   d = (by2 - by1) * (ax2 - ax1) - (bx2 - bx1) * (ay2 - ay1)
   if d = 0
      return
   .
   ua = ((bx2 - bx1) * (ay1 - by1) - (by2 - by1) * (ax1 - bx1)) / d
   ub = ((ax2 - ax1) * (ay1 - by1) - (by2 - by1) * (ax1 - bx1)) / d
   if abs ua > 1 or abs ub > 1
      return
   .
   rx = ax1 + ua * (ax2 - ax1)
   ry = ay1 + ua * (ay2 - ay1)
.
intersect 4 0 6 10 0 3 10 7 rx ry
print rx & " " & ry
intersect 4 0 6 10 0 3 10 7.1 rx ry
print rx & " " & ry
intersect 0 0 1 1 1 2 4 5 rx ry
print rx & " " & ry
