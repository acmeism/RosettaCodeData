object SequenceGenerator {

  def main(args: Array[String]): Unit = {
    val result = generateSequence(5, 13)
    println(result) // Should print 1001010010100
  }

  def generateSequence(k: Int, n: Int): String = {
    var s = List.fill(n)(List(0)).zipWithIndex.map { case (list, index) =>
      if (index < k) List(1) else List(0)
    }

    var (d, nVar, kVar, z) = (n - k, math.max(k, n - k), math.min(k, n - k), n - k)

    while (z > 0 || kVar > 1) {
      for (i <- 0 until kVar) {
        s = s.updated(i, s(i) ++ s(s.size - 1 - i))
      }
      s = s.take(s.size - kVar)
      z -= kVar
      d = nVar - kVar
      nVar = math.max(kVar, d)
      kVar = math.min(kVar, d)
    }

    s.flatten.mkString
  }
}
