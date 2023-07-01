object LinearCombination extends App {
    val combos = Seq(Seq(1, 2, 3), Seq(0, 1, 2, 3),
      Seq(1, 0, 3, 4), Seq(1, 2, 0), Seq(0, 0, 0), Seq(0),
      Seq(1, 1, 1), Seq(-1, -1, -1), Seq(-1, -2, 0, -3), Seq(-1))

  private def linearCombo(c: Seq[Int]): String = {
    val sb = new StringBuilder
    for {i <- c.indices
         term = c(i)
         if term != 0} {
      val av = math.abs(term)
      def op = if (term < 0 && sb.isEmpty) "-"
      else if (term < 0) " - "
      else if (term > 0 && sb.isEmpty) "" else " + "

      sb.append(op).append(if (av == 1) "" else s"$av*").append("e(").append(i + 1).append(')')
    }
    if (sb.isEmpty) "0" else sb.toString
  }
    for (c <- combos) {
      println(f"${c.mkString("[", ", ", "]")}%-15s  ->  ${linearCombo(c)}%s")
    }
}
