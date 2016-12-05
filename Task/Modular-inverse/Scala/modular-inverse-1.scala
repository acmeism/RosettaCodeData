def gcdExt(u: Int, v: Int): (Int, Int, Int) = {
  @tailrec
  def aux(a: Int, b: Int, x: Int, y: Int, x1: Int, x2: Int, y1: Int, y2: Int): (Int, Int, Int) = {
    if(b == 0) (x, y, a) else {
      val (q, r) = (a / b, a % b)
      aux(b, r, x2 - q * x1, y2 - q * y1, x, x1, y, y1)
    }
  }
  aux(u, v, 1, 0, 0, 1, 1, 0)
}

def modInv(a: Int, m: Int): Option[Int] = {
  val (i, j, g) = gcdExt(a, m)
  if (g == 1) Option(if (i < 0) i + m else i) else Option.empty
}
