import math, complex

proc rect(r, phi: float): Complex = (r * cos(phi), sin(phi))
proc phase(c: Complex): float = arctan2(c.im, c.re)

proc radians(x: float): float = (x * Pi) / 180.0
proc degrees(x: float): float = (x * 180.0) / Pi

proc meanAngle(deg: openArray[float]): float =
  var c: Complex
  for d in deg:
    c += rect(1.0, radians(d))
  degrees(phase(c / float(deg.len)))

echo "The 1st mean angle is: ", meanAngle([350.0, 10.0]), " degrees"
echo "The 2nd mean angle is: ", meanAngle([90.0, 180.0, 270.0, 360.0]), " degrees"
echo "The 3rd mean angle is: ", meanAngle([10.0, 20.0, 30.0]), " degrees"
