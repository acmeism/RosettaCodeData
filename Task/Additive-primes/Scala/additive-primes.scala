def isPrime(n: Int): Boolean = {
  @annotation.tailrec
  def checkDivisor(d: Int): Boolean = {
    if (d * d > n) true
    else if (n % d == 0) false
    else checkDivisor(d + 2)
  }

  if (n < 2) false
  else if (n == 2 || n == 3) true
  else if (n % 2 == 0 || n % 3 == 0) false
  else checkDivisor(5)
}

private def digitSum(n: Int): Int = n.toString.map(_ - '0').sum

private def additivePrime(n: Int): Boolean = isPrime(n) && isPrime(digitSum(n))

private def testAdditivePrime(max: Int): Unit = {
  val result = (2 to max).filter(additivePrime)
  println(result.mkString(", "))
  println(s"Found ${result.length} additive primes less than 500.")
}

@main def main(): Unit =
  testAdditivePrime(500)
