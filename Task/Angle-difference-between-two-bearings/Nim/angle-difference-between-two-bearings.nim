import math
import strutils


proc delta(b1, b2: float) : float =
  result = (b2 - b1) mod 360.0

  if result < -180.0:
    result += 360.0
  elif result >= 180.0:
    result -= 360.0


let testVectors : seq[tuple[b1, b2: float]] = @[
      (20.00,       45.00 ),
     (-45.00,       45.00 ),
     (-85.00,       90.00 ),
     (-95.00,       90.00 ),
     (-45.00,      125.00 ),
     (-45.00,      145.00 ),
     ( 29.48,      -88.64 ),
     (-78.33,     -159.04 ),
  (-70099.74,    29840.67 ),
 (-165313.67,    33693.99 ),
    (1174.84,  -154146.66 ),
   (60175.77,    42213.07 ) ]

for vector in testVectors:
  echo vector.b1.formatFloat(ffDecimal, 2).align(13) &
       vector.b2.formatFloat(ffDecimal, 2).align(13) &
       delta(vector.b1, vector.b2).formatFloat(ffDecimal, 2).align(13)
