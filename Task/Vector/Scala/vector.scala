object Vector extends App {

  case class Vector2D(x: Double, y: Double) {
    def +(v: Vector2D) = Vector2D(x + v.x, y + v.y)

    def -(v: Vector2D) = Vector2D(x - v.x, y - v.y)

    def *(s: Double) = Vector2D(s * x, s * y)

    def /(s: Double) = Vector2D(x / s, y / s)

    override def toString() = s"Vector($x, $y)"
  }

  val v1 = Vector2D(5.0, 7.0)
  val v2 = Vector2D(2.0, 3.0)
  println(s"v1 = $v1")
  println(s"v2 = $v2\n")

  println(s"v1 + v2 = ${v1 + v2}")
  println(s"v1 - v2 = ${v1 - v2}")
  println(s"v1 * 11 = ${v1 * 11.0}")
  println(s"11 * v2 = ${v2 * 11.0}")
  println(s"v1 / 2  = ${v1 / 2.0}")

  println(s"\nSuccessfully completed without errors. [total ${scala.compat.Platform.currentTime - executionStart} ms]")
}
