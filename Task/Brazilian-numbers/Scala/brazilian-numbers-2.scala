object Brazilian extends App {

  def oddPrimes =
    LazyList.from(3, 2).filter(p => (3 to math.sqrt(p).ceil.toInt by 2).forall(p % _ > 0))
  val primes = 2 #:: oddPrimes

  def sameDigits(num: Int, base: Int): Boolean = {
    val first = num % base
    @annotation.tailrec
    def iter(num: Int): Boolean = {
      if (num % base) == first then iter(num / base)
      else num == 0
    }
    iter(num / base)
  }

  def isBrazilian(num: Int): Boolean = {
    num match {
      case x if x < 7 => false
      case x if (x & 1) == 0 => true
      case _ => (2 to num - 2).exists(sameDigits(num,_))
    }
  }

  val (limit, bigLimit) = (20, 100_000)

  val doList = Seq(("brazilian", LazyList.from(7)),
                  ("odd", LazyList.from(7, 2)),
                  ("prime", primes))
  for((listStr, stream) <- doList)
    println(s"$listStr: " + stream.filter(isBrazilian(_)).take(limit).toList)

  println("be a little patient, it will take some time")
  val bigElement = LazyList.from(7).filter(isBrazilian(_)).drop(bigLimit - 1).take(1).head
  println(s"brazilian($bigLimit): $bigElement")
}
