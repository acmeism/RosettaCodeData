  def bico(n: Long, k: Long): Long = (n, k) match {
    case (n, 0) => 1
    case (0, k) => 0
    case (n, k) => bico(n - 1, k - 1) + bico(n - 1, k)
  }
  println("bico(5,3) = " + bico(5, 3))
