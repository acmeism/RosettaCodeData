object CantorSetQD extends App {
  val (width, height) = (81, 5)

  val lines = Seq.fill[Array[Char]](height)(Array.fill[Char](width)('*'))

  def cantor(start: Int, len: Int, index: Int) {
    val seg = len / 3

    println(start, len, index)

    if (seg != 0) {
      for (i <- index until height;
           j <- (start + seg) until (start + seg * 2)) lines(i)(j) = ' '

      cantor(start, seg, index + 1)
      cantor(start + seg * 2, seg, index + 1)
    }
  }

  cantor(0, width, 1)
  lines.foreach(l => println(l.mkString))
}
