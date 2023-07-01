object CombSort extends App {
  val ia = Array(28, 44, 46, 24, 19, 2, 17, 11, 25, 4)
  val ca = Array('X', 'B', 'E', 'A', 'Z', 'M', 'S', 'L', 'Y', 'C')

  def sorted[E](input: Array[E])(implicit ord: Ordering[E]): Array[E] = {
    import ord._
    var gap = input.length
    var swapped = true
    while (gap > 1 || swapped) {
      if (gap > 1) gap = (gap / 1.3).toInt
      swapped = false
      for (i <- 0 until input.length - gap)
        if (input(i) >= input(i + gap)) {
          val t = input(i)
          input(i) = input(i + gap)
          input(i + gap) = t
          swapped = true
        }
    }
    input
  }

  println(s"Unsorted : ${ia.mkString("[", ", ", "]")}")
  println(s"Sorted   : ${sorted(ia).mkString("[", ", ", "]")}\n")

  println(s"Unsorted : ${ca.mkString("[", ", ", "]")}")
  println(s"Sorted   : ${sorted(ca).mkString("[", ", ", "]")}")

}
