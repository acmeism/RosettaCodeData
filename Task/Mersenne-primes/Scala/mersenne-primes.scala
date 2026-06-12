object MersennePrimes extends App {

  val primes = primeSieve(LazyList.from(2))
  val upbPrime = 9941

  def primeSieve(s: LazyList[Int]): LazyList[Int] =
    s.head #:: primeSieve(s.tail filter {
      _ % s.head != 0
    })

  def mersenne(p: Int): BigInt = (BigInt(2) pow p) - 1

  def s(mp: BigInt, p: Int): BigInt = {
    if (p == 1) 4 else ((s(mp, p - 1) pow 2) - 2) % mp
  }
  println(s"Finding Mersenne primes in M[2..$upbPrime]")
  ((primes takeWhile (_ <= upbPrime)).map { p => (p, mersenne(p)) }
    map { p => if (p._1 == 2) (p, 0) else (p, s(p._2, p._1 - 1)) } filter {
    _._2 == 0
  })
    .foreach { p =>
      println(s"prime M${(p._1)._1}: " + {
        if ((p._1)._1 < 200) (p._1)._2 else s"(${(p._1)._2.toString.length} digits)"
      })
    }
  println("That's All Folks!")
}
