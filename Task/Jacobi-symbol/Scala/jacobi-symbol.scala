def jacobi(a_p: Int, n_p: Int): Int =
{
    var a = a_p
    var n = n_p
    if (n <= 0) return -1
    if (n % 2 == 0) return -1

    a %= n
    var result = 1
    while (a != 0) {
      while (a % 2 == 0) {
        a /= 2
        if (n % 8 == 3 || n % 8 == 5) result = -result
      }
      val t = a
      a = n
      n = t
      if (a % 4 == 3 && n % 4 == 3) result = -result
      a %= n
    }
    if (n != 1) result = 0

    result
}

def main(args: Array[String]): Unit =
{
    for {
      a <- 0 until 11
      n <- 1 until 31 by 2
    } yield println("n = " + n + ", a = " + a + ": " + jacobi(a, n))
}
