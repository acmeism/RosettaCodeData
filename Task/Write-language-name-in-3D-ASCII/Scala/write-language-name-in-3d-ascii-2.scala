import scala.collection.mutable.ArraySeq

object Ascii3D extends App {
  def ASCII3D = {
    val picture = """               *
   **  **  *   *    *
  *   *   * *  *   * *
  *   *   * *  *   * *
   *  *   ***  *   ***
    * *   * *  *   * *
    * *   * *  *   * *
  **   ** *  * *** * *
                     *
                      *""".split("\n")

    var arr = {
      val (x, y) = // Get maximal format and create a 2-D array with it.
        (picture.foldLeft(0)((i, s) => i max s.length), picture.size)
      ArraySeq.fill(y + 1, (x * 3) + (y + 1))(' ')
    }

    //
    // Map asterisks to 3D cube
    //
    val (cubeTop, cubeBottom) = ("""///\""", """\\\/""") // "

    for {
      y <- 0 until picture.size
      x <- 0 until picture(y).size
      if picture(y)(x) == '*'
      indent = picture.size - y
    } {
      arr(y) = arr(y) patch ((x * 3 + indent), cubeTop, cubeTop.size)
      arr(y + 1) = arr(y + 1) patch ((x * 3 + indent), cubeBottom, cubeBottom.size)
    }
    // Transform array to String
    arr.map(_.mkString).mkString("\n")
  }

  println(ASCII3D)
}
