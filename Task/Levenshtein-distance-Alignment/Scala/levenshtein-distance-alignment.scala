import scala.collection.mutable
import scala.collection.parallel.ParSeq

object LevenshteinAlignment extends App {
  val vlad = new Levenshtein("rosettacode", "raisethysword")
  val alignment = vlad.revLevenstein()

  class Levenshtein(s1: String, s2: String) {
    val memoizedCosts = mutable.Map[(Int, Int), Int]()

    def revLevenstein(): (String, String) = {
      def revLev: (Int, Int, String, String) => (String, String) = {
        case (_, 0, revS1, revS2) => (revS1, revS2)
        case (0, _, revS1, revS2) => (revS1, revS2)
        case (i, j, revS1, revS2) =>
          if (memoizedCosts(i, j) == (memoizedCosts(i - 1, j - 1)
                                      + (if (s1(i - 1) != s2(j - 1)) 1 else 0)))
            revLev(i - 1, j - 1, s1(i - 1) + revS1, s2(j - 1) + revS2)
          else if (memoizedCosts(i, j) == 1 + memoizedCosts(i - 1, j))
            revLev(i - 1, j, s1(i - 1) + revS1, "-" + revS2)
          else
            revLev(i, j - 1, "-" + revS1, s2(j - 1) + revS2)
      }

      revLev(s1.length, s2.length, "", "")
    }

    private def levenshtein: Int = {
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
    }

    levenshtein
  }

  println(alignment._1)
  println(alignment._2)

}
