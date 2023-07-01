object PascalTriangle extends App {

  val (x, y, z) = pascal(11, 4, 40, 151)

  def pascal(a: Int, b: Int, mid: Int, top: Int): (Int, Int, Int) = {
    val y = (top - 4 * (a + b)) / 7
    val x = mid - 2 * a - y
    (x, y, y - x)
  }

  println(if (x != 0) s"Solution is: x = $x, y = $y, z = $z" else "There is no solution.")
}
