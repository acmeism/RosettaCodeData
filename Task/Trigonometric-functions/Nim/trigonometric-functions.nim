import math, strformat

let rad = Pi/4
let deg = 45.0

echo &"Sine:       {sin(rad):.10f} {sin(degToRad(deg)):13.10f}"
echo &"Cosine :    {cos(rad):.10f} {cos(degToRad(deg)):13.10f}"
echo &"Tangent:    {tan(rad):.10f} {tan(degToRad(deg)):13.10f}"
echo &"Arcsine:    {arcsin(sin(rad)):.10f} {radToDeg(arcsin(sin(degToRad(deg)))):13.10f}"
echo &"Arccosine:  {arccos(cos(rad)):.10f} {radToDeg(arccos(cos(degToRad(deg)))):13.10f}"
echo &"Arctangent: {arctan(tan(rad)):.10f} {radToDeg(arctan(tan(degToRad(deg)))):13.10f}"
