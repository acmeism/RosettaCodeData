import math

proc radians(x): float = x * Pi / 180
proc degrees(x): float = x * 180 / Pi

let rad = Pi/4
let deg = 45.0

echo "Sine: ", sin(rad), " ", sin(radians(deg))
echo "Cosine : ", cos(rad), " ", cos(radians(deg))
echo "Tangent: ", tan(rad), " ", tan(radians(deg))
echo "Arcsine: ", arcsin(sin(rad)), " ", degrees(arcsin(sin(radians(deg))))
echo "Arccocose: ", arccos(cos(rad)), " ", degrees(arccos(cos(radians(deg))))
echo "Arctangent: ", arctan(tan(rad)), " ", degrees(arctan(tan(radians(deg))))
