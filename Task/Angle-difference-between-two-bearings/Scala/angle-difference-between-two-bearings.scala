object AngleDifference extends App {
  private def getDifference(b1: Double, b2: Double) = {
    val r = (b2 - b1) % 360.0
    if (r < -180.0) r + 360.0 else if (r >= 180.0) r - 360.0 else r
  }

  println("Input in -180 to +180 range")
  println(getDifference(20.0, 45.0))
  println(getDifference(-45.0, 45.0))
  println(getDifference(-85.0, 90.0))
  println(getDifference(-95.0, 90.0))
  println(getDifference(-45.0, 125.0))
  println(getDifference(-45.0, 145.0))
  println(getDifference(-45.0, 125.0))
  println(getDifference(-45.0, 145.0))
  println(getDifference(29.4803, -88.6381))
  println(getDifference(-78.3251, -159.036))

  println("Input in wider range")
  println(getDifference(-70099.74233810938, 29840.67437876723))
  println(getDifference(-165313.6666297357, 33693.9894517456))
  println(getDifference(1174.8380510598456, -154146.66490124757))
  println(getDifference(60175.77306795546, 42213.07192354373))

}
