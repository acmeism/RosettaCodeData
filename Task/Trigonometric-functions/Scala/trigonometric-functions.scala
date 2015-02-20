import scala.math._

object Gonio extends App {
  //Pi / 4 rad is 45 degrees. All answers should be the same.
  val radians = Pi / 4
  val degrees = 45.0

  println(s"${sin(radians)} ${sin(toRadians(degrees))}")
  //cosine
  println(s"${cos(radians)} ${cos(toRadians(degrees))}")
  //tangent
  println(s"${tan(radians)} ${tan(toRadians(degrees))}")
  //arcsine
  val bgsin = asin(sin(radians))
  println(s"$bgsin ${toDegrees(bgsin)}")
  val bgcos = acos(cos(radians))
  println(s"$bgcos ${toDegrees(bgcos)}")
  //arctangent
  val bgtan = atan(tan(radians))
  println(s"$bgtan ${toDegrees(bgtan)}")
  val bgtan2 = atan2(1, 1)
  println(s"$bgtan ${toDegrees(bgtan)}")
}
