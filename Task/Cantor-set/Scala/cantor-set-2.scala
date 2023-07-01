object CantorSetFP extends App {
  val (width, height) = (81, 5)

  def lines = (1 to height).map(_ => (0 until width).toSet)

  def cantorSet(pre: Seq[Set[Int]], start: Int, len: Int, index: Int): Seq[Set[Int]] = {
    val seg = len / 3

    def cantorSet1(pre: Seq[Set[Int]], start: Int, index: Int): Seq[Set[Int]] = {
      def elementsStuffing(pre: Set[Int], start: Int): Set[Int] =
        pre -- ((start + seg) until (start + seg * 2))

      for (n <- 0 until height)
        yield if (index to height contains n) elementsStuffing(pre(n), start)
        else pre(n)
    }

    if (seg == 0) pre
    else {
      def version0 = cantorSet1(pre, start, index)
      def version1 = cantorSet(cantorSet1(pre, start, index), start, seg, index + 1)

      cantorSet(version1, start + seg * 2, seg, index + 1)
    }
  }

  def output: Seq[Set[Int]] = cantorSet(lines, 0, width, 1)

  println(
    output.map(l => (0 to width).map(pos => if (l contains pos) '*' else ' ').mkString)
      .mkString("\n"))
}
