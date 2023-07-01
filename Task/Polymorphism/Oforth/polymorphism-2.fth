: testPoly
| p c |
   Point new(3, 4) ->p
   p println
   System.Out "Attributes of this point are : " << p _x << " and " << p _y << cr
   Circle new(5, 6, 7.1) ->c
   c println
   System.Out "Attributes of this circle are : " << c _x << ",  " << c _y << " and " << c _r << cr
   Circle newFromPoint(p, 2) println ;
