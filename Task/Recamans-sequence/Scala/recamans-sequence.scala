import scala.collection.mutable

object RecamansSequence extends App {
  val (a, used) = (mutable.ArrayBuffer[Int](0), mutable.BitSet())
  var (foundDup, hop, nUsed1000) = (false, 1, 0)

  while (nUsed1000 < 1000) {
    val _next = a(hop - 1) - hop
    val next = if (_next < 1 || used.contains(_next)) _next + 2 * hop else _next
    val alreadyUsed = used.contains(next)

    a += next
    if (!alreadyUsed) {
      used.add(next)
      if (next <= 1000) nUsed1000 += 1
    }
    if (!foundDup && alreadyUsed) {
      println(s"The first duplicate term is a($hop) = $next")
      foundDup = true
    }
    if (nUsed1000 == 1000)
      println(s"Terms up to $hop are needed to generate 0 to 1000")

    hop += 1
  }

  println(s"The first 15 terms of the Recaman sequence are : ${a.take(15)}")

}
