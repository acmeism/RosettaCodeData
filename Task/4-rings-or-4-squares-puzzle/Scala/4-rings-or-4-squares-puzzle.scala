object FourRings {

  def fourSquare(low: Int, high: Int, unique: Boolean, print: Boolean): Unit = {
    def isValid(needle: Integer, haystack: Integer*) = !unique || !haystack.contains(needle)

    if (print) println("a b c d e f g")

    var count = 0
    for {
      a <- low to high
      b <- low to high if isValid(a, b)
      fp = a + b
      c <- low to high if isValid(c, a, b)
      d <- low to high if isValid(d, a, b, c) && fp == b + c + d
      e <- low to high if isValid(e, a, b, c, d)
      f <- low to high if isValid(f, a, b, c, d, e) && fp == d + e + f
      g <- low to high if isValid(g, a, b, c, d, e, f) && fp == f + g
    } {
      count += 1
      if (print) println(s"$a $b $c $d $e $f $g")
    }

    println(s"There are $count ${if(unique) "unique" else "non-unique"} solutions in [$low, $high]")
  }

  def main(args: Array[String]): Unit = {
    fourSquare(1, 7, unique = true, print = true)
    fourSquare(3, 9, unique = true, print = true)
    fourSquare(0, 9, unique = false, print = false)
  }
}
