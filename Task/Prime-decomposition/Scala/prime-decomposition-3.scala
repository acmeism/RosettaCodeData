import scala.math.BigInt
	
def primeStream(s: Stream[Int]): Stream[Int] = {
  Stream.cons(s.head, primeStream(s.tail filter { _ % s.head != 0 }))
}

// An infinite stream of primes
val primes = primeStream(Stream.from(2))

	
def primeFactor(n:BigInt) = { primes.takeWhile(_ <= n).find(i => n % i == 0) }
	
def decompose( n : BigInt ) : List[BigInt] = {
  primeFactor(n) match {
    case Some(a) => a.toInt :: decompose(n/a)
    case None => Nil
  }
}
