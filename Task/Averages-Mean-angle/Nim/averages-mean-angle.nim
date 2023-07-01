import math, complex

proc meanAngle(deg: openArray[float]): float =
  var c: Complex[float]
  for d in deg:
    c += rect(1.0, degToRad(d))
  radToDeg(phase(c / float(deg.len)))

echo "The 1st mean angle is: ", meanAngle([350.0, 10.0]), " degrees"
echo "The 2nd mean angle is: ", meanAngle([90.0, 180.0, 270.0, 360.0]), " degrees"
echo "The 3rd mean angle is: ", meanAngle([10.0, 20.0, 30.0]), " degrees"
