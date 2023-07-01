def nroot(n: Int, a: Double): Double = {
  @tailrec
  def rec(x0: Double) : Double = {
    val x1 = ((n - 1) * x0 + a/math.pow(x0, n-1))/n
    if (x0 <= x1) x0 else rec(x1)
  }

  rec(a)
}
