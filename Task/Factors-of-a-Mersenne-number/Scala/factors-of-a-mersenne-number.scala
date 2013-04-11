import scala.math.BigInt

def factorMersenne( p:BigInt ) : Option[BigInt] = {

  val two = BigInt("2")

  val factorLimit : BigInt = (two pow p.toInt) - 1
  val limit = factorLimit min (math.sqrt(Long.MaxValue).toInt)


  def factorTest( p : BigInt, q : BigInt ) : Boolean = {

    // Is q an early factor?
    if(
      two.modPow(p,q) == 1 &&                                         // number divides 2**P-1
      ((q % 8).toInt match {case 1 | 7 => true; case _ => false}) &&  // mod(8) is of 1 or 7
      q.isProbablePrime(7)                                            // it is a prime number
    )
      {true}
    else
      {false}
  }

  // Build a stream of factors from (2*p+1) step-by (2*p)
  def s(a:BigInt) : Stream[BigInt] = a #:: s(a + (two * p))  // Build stream of possible factors

  // Limit and Filter Stream and then take the head element
  val e = s(two*p+1).takeWhile(_ < limit).filter(factorTest(p,_))
  e.headOption
}

val l = List(2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,929)

// Test
l.foreach(p => println( "M" + p + ": " + (factorMersenne(p) getOrElse "prime") ))

/*
Results:
M2: prime
M3: prime
M5: prime
M7: prime
M11: 23
M13: prime
M17: prime
M19: prime
M23: 47
M29: 233
M31: prime
M37: 223
M41: 13367
M43: 431
M47: 2351
M53: 6361
M59: 179951
M61: prime
M67: 193707721
M71: 228479
M73: 439
M79: 2687
M83: 167
M89: prime
M97: 11447
M929: 13007
*/
