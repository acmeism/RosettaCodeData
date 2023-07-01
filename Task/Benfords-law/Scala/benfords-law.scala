// Fibonacci Sequence (begining with 1,1): 1 1 2 3 5 8 13 21 34 55 ...
val fibs : Stream[BigInt] = { def series(i:BigInt,j:BigInt):Stream[BigInt] = i #:: series(j, i+j); series(1,0).tail.tail }


/**
 * Given a numeric sequence, return the distribution of the most-signicant-digit
 * as expected by Benford's Law and then by actual distribution.
 */
def benford[N:Numeric]( data:Seq[N] ) : Map[Int,(Double,Double)] = {

  import scala.math._

  val maxSize = 10000000  // An arbitrary size to avoid problems with endless streams

  val size = (data.take(maxSize)).size.toDouble

  val distribution = data.take(maxSize).groupBy(_.toString.head.toString.toInt).map{ case (d,l) => (d -> l.size) }

  (for( i <- (1 to 9) ) yield { (i -> (log10(1D + 1D / i), (distribution(i) / size))) }).toMap
}

{
  println( "Fibonacci Sequence (size=1000): 1 1 2 3 5 8 13 21 34 55 ...\n" )
  println( "%9s %9s %9s".format( "Actual", "Expected", "Deviation" ) )

  benford( fibs.take(1000) ).toList.sorted foreach {
    case (k, v) => println( "%d: %5.2f%% | %5.2f%% | %5.4f%%".format(k,v._2*100,v._1*100,math.abs(v._2-v._1)*100) )
  }
}
