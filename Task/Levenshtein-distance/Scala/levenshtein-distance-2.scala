import scala.collection.mutable
import scala.collection.parallel.ParSeq

object Levenshtein extends App {

  def printDistance(s1: String, s2: String) =
    println(f"$s1%s -> $s2%s : ${levenshtein(s1, s2)(s1.length, s2.length)}%d")

  def levenshtein(s1: String, s2: String): mutable.Map[(Int, Int), Int] = {
    val memoizedCosts = mutable.Map[(Int, Int), Int]()

    def lev: ((Int, Int)) => Int = {
      case (k1, k2) =>
        memoizedCosts.getOrElseUpdate((k1, k2), (k1, k2) match {
          case (i, 0) => i
          case (0, j) => j
          case (i, j) =>
            ParSeq(1 + lev((i - 1, j)),
              1 + lev((i, j - 1)),
              lev((i - 1, j - 1))
                + (if (s1(i - 1) != s2(j - 1)) 1 else 0)).min
        })
    }

    lev((s1.length, s2.length))
    memoizedCosts
  }

  printDistance("kitten", "sitting")
  printDistance("rosettacode", "raisethysword")
  printDistance("Here's a bunch of words", "to wring out this code")
  printDistance("sleep", "fleeting")

}
