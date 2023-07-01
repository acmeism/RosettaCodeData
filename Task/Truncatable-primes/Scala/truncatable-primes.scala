object TruncatablePrimes {
  def main(args: Array[String]): Unit = {
    val max = 1000000

    println(
      s"""|ltPrime: ${ltPrimes.takeWhile(_ <= max).last}
          |rtPrime: ${rtPrimes.takeWhile(_ <= max).last}
          |""".stripMargin)
  }

  def ltPrimes: LazyList[Int] = 2 #:: LazyList.from(3, 2).filter(isLeftTruncPrime)
  def rtPrimes: LazyList[Int] = 2 #:: LazyList.from(3, 2).filter(isRightTruncPrime)

  def isPrime(num: Int): Boolean = (num > 1) && !LazyList.range(3, math.sqrt(num).toInt + 1, 2).exists(num%_ == 0)
  def isLeftTruncPrime(num: Int): Boolean = !num.toString.contains('0') && Iterator.unfold(num.toString){str => if(str.nonEmpty) Some((str.toInt, str.tail)) else None}.forall(isPrime)
  def isRightTruncPrime(num: Int): Boolean = !num.toString.exists(_.asDigit%2 == 0) && Iterator.unfold(num.toString){str => if(str.nonEmpty) Some((str.toInt, str.init)) else None}.forall(isPrime)
}
