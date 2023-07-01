object PointCircle extends App {

  class Point(x: Int = 0, y: Int = 0) {

    def copy(x: Int = this.x, y: Int = this.y): Point = new Point(x, y)

    override def toString = s"Point x: $x,  y: $y"
  }

  object Point {
    def apply(x: Int = 0, y: Int = 0): Point = new Point(x, y)
  }

  case class Circle(x: Int = 0, y: Int = 0, r: Int = 0) extends Point(x, y) {

    def copy(r: Int): Circle = Circle(x, y, r)

    override def toString = s"Circle x: $x,  y: $y,  r: $r"
  }

  val p = Point()
  val c = Circle()
  println("Instantiated ", p)
  println("Instantiated ", c)

  val q = Point(5, 6)
  println("Instantiated ", q)
  val r = q.copy(y = 7) // change y coordinate
  println(r, " changed y coordinate")

  val d = Circle(5, 6, 7)
  println("Instantiated ", d)
  val e = d.copy(r = 8) // change radius
  println(e, " changed radius")

}
