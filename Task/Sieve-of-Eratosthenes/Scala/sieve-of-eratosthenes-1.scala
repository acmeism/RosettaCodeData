import scala.annotation.tailrec
import scala.collection.parallel.mutable
import scala.compat.Platform

object GenuineEratosthenesSieve extends App {
  def sieveOfEratosthenes(limit: Int) = {
    val (primes: mutable.ParSet[Int], sqrtLimit) = (mutable.ParSet.empty ++ (2 to limit), math.sqrt(limit).toInt)
    @tailrec
    def prim(candidate: Int): Unit = {
      if (candidate <= sqrtLimit) {
        if (primes contains candidate) primes --= candidate * candidate to limit by candidate
        prim(candidate + 1)
      }
    }
    prim(2)
    primes
  }
  // BitSet toList is shuffled when using the ParSet version. So it has to be sorted before using it as a sequence.

  assert(sieveOfEratosthenes(15099480).size == 976729)
  println(s"Successfully completed without errors. [total ${Platform.currentTime - executionStart} ms]")
}
