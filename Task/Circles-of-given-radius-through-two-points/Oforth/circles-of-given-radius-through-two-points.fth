: circleCenter(x1, y1, x2, y2, r)
| d xmid ymid r1 md |
   x2 x1 - sq  y2 y1 - sq + sqrt -> d
   x1 x2 + 2 / -> xmid
   y1 y2 + 2 / -> ymid
   2 r * -> r1

   d 0.0 == ifTrue: [ "Infinite number of circles" . return ]
   d r1 == ifTrue:  [ System.Out "One circle: (" << xmid << ", " << ymid << ")" << cr return ]
   d r1  > ifTrue:  [ "No circle" . return ]

   r sq d 2 / sq - sqrt ->md

   System.Out "C1 : (" << xmid y1 y2 - md * d / + << ", " << ymid x2 x1 - md * d / + << ")" << cr
   System.Out "C2 : (" << xmid y1 y2 - md * d / - << ", " << ymid x2 x1 - md * d / - << ")" << cr
;
