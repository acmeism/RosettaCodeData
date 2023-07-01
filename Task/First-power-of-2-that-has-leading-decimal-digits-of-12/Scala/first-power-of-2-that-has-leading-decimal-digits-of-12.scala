object FirstPowerOfTwo {
  def p(l: Int, n: Int): Int = {
    var n2 = n
    var test = 0
    val log = math.log(2) / math.log(10)
    var factor = 1
    var loop = l
    while (loop > 10) {
      factor *= 10
      loop /= 10
    }
    while (n2 > 0) {
      test += 1
      val value = (factor * math.pow(10, test * log % 1)).asInstanceOf[Int]
      if (value == l) {
        n2 -= 1
      }
    }
    test
  }

  def runTest(l: Int, n: Int): Unit = {
    printf("p(%d, %d) = %,d%n", l, n, p(l, n))
  }

  def main(args: Array[String]): Unit = {
    runTest(12, 1)
    runTest(12, 2)
    runTest(123, 45)
    runTest(123, 12345)
    runTest(123, 678910)
  }
}
