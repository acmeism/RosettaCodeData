/* We could reduce the number of functions through a polymorphism since we're trying to retrieve sexy N-tuples (pairs, triplets etc...)
  but one practical solution would be to use the Shapeless library for this purpose; here we only use built-in Scala packages. */

object SexyPrimes {

  /** Check if an input number is prime or not*/
  def isPrime(n: Int): Boolean = ! ((2 until n-1) exists (n % _ == 0)) && n > 1

  /** Retrieve pairs of sexy primes given a list of Integers*/
  def getSexyPrimesPairs (primes : List[Int]) = {
    primes
      .map(n => if(primes.contains(n+6)) (n, n+6))
      .filter(p => p != ())
      .map{ case (a,b) => (a.toString.toInt, b.toString.toInt)}
  }

  /** Retrieve triplets of sexy primes given a list of Integers*/
  def getSexyPrimesTriplets (primes : List[Int]) = {
    primes
      .map(n => if(
        primes.contains(n+6) && primes.contains(n+12))
        (n, n+6, n+12)
      )
      .filter(p => p != ())
      .map{ case (a,b,c) => (a.toString.toInt, b.toString.toInt, c.toString.toInt)}
  }

  /** Retrieve quadruplets of sexy primes given a list of Integers*/
  def getSexyPrimesQuadruplets (primes : List[Int]) = {
    primes
      .map(n => if(
        primes.contains(n+6) && primes.contains(n+12) && primes.contains(n+18))
        (n, n+6, n+12, n+18)
      )
      .filter(p => p != ())
      .map{ case (a,b,c,d) => (a.toString.toInt, b.toString.toInt, c.toString.toInt, d.toString.toInt)}
  }

  /** Retrieve quintuplets of sexy primes given a list of Integers*/
  def getSexyPrimesQuintuplets (primes : List[Int]) = {
    primes
      .map(n => if (
        primes.contains(n+6) && primes.contains(n+12) && primes.contains(n+18) && primes.contains(n + 24))
        (n, n + 6, n + 12, n + 18, n + 24)
      )
      .filter(p => p != ())
      .map { case (a, b, c, d, e) => (a.toString.toInt, b.toString.toInt, c.toString.toInt, d.toString.toInt, e.toString.toInt) }

  }

  /** Retrieve all unsexy primes between 1 and a given limit from an input list of Integers*/
  def removeOutsideSexyPrimes( l : List[Int], limit : Int) : List[Int] = {
    l.filter(n => !isPrime(n+6) && n+6 < limit)
  }

  def main(args: Array[String]): Unit = {
    val limit = 1000035
    val l = List.range(1,limit)
    val primes = l.filter( n => isPrime(n))

    val sexyPairs = getSexyPrimesPairs(primes)
    println("Number of sexy pairs : " + sexyPairs.size)
    println("5 last sexy pairs : " + sexyPairs.takeRight(5))

    val primes2 = sexyPairs.flatMap(t => List(t._1, t._2)).distinct.sorted
    val sexyTriplets = getSexyPrimesTriplets(primes2)
    println("Number of sexy triplets : " + sexyTriplets.size)
    println("5 last sexy triplets : " + sexyTriplets.takeRight(5))

    val primes3 = sexyTriplets.flatMap(t => List(t._1, t._2, t._3)).distinct.sorted
    val sexyQuadruplets = getSexyPrimesQuadruplets(primes3)
    println("Number of sexy quadruplets : " + sexyQuadruplets.size)
    println("5 last sexy quadruplets : " + sexyQuadruplets.takeRight(5))

    val primes4 = sexyQuadruplets.flatMap(t => List(t._1, t._2, t._3, t._4)).distinct.sorted
    val sexyQuintuplets = getSexyPrimesQuintuplets(primes4)
    println("Number of sexy quintuplets : " + sexyQuintuplets.size)
    println("The last sexy quintuplet : " + sexyQuintuplets.takeRight(10))

    val sexyPrimes = primes2.toSet
    val unsexyPrimes = removeOutsideSexyPrimes( primes.toSet.diff((sexyPrimes)).toList.sorted, limit)
    println("Number of unsexy primes : " + unsexyPrimes.size)
    println("10 last unsexy primes : " + unsexyPrimes.takeRight(10))

  }

}
