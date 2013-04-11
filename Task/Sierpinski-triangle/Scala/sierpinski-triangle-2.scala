def sierpinski(n: Int) {
  def star(n: Long) = if ((n & 1L) == 1L) "*" else " "
  def stars(n: Long): String = if (n == 0L) "" else star(n) + " " + stars(n >> 1)
  def spaces(n: Int) = " " * n
  ((1 << n) - 1 to 0 by -1).foldLeft(1L) {
    case (bitmap, remainingLines) =>
      println(spaces(remainingLines) + stars(bitmap))
      (bitmap << 1) ^ bitmap
  }
}
