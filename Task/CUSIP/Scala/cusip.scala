object Cusip extends App {

  val candidates = Seq("037833100", "17275R102", "38259P508", "594918104", "68389X106", "68389X105")

  for (candidate <- candidates)
    printf(f"$candidate%s -> ${if (isCusip(candidate)) "correct" else "incorrect"}%s%n")

  private def isCusip(s: String): Boolean = {
    if (s.length != 9) false
    else {
      var sum = 0
      for (i <- 0 until 7) {
        val c = s(i)
        var v = 0
        if (c >= '0' && c <= '9') v = c - 48
        else if (c >= 'A' && c <= 'Z') v = c - 55 // lower case letters apparently invalid
        else if (c == '*') v = 36
        else if (c == '@') v = 37
        else if (c == '#') v = 38
        else return false
        if (i % 2 == 1) v *= 2 // check if odd as using 0-based indexing
        sum += v / 10 + v % 10
      }
      s(8) - 48 == (10 - (sum % 10)) % 10
    }
  }

}
