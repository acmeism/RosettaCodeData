object NegativeBase {
  val digits = ('0' to '9') ++ ('a' to 'z') ++ ('A' to 'Z')

  def intToStr(n: Int, b: Int): String = {
    def _fromInt(n: Int): List[Int] = {
      if (n == 0) {
        Nil
      } else {
        val r = n % b
        val rp = if (r < 0) r + b else r
        val m = -(n - rp)/b
        rp :: _fromInt(m)
      }
    }
    _fromInt(n).map(digits).reverse.mkString
  }

  def strToInt(s: String, b: Int): Int = {
    s.map(digits.indexOf).foldRight((0, 1)){ case (x, (sum, pow)) =>
      (sum + x * pow, pow * -b)
    }._1
  }
}
