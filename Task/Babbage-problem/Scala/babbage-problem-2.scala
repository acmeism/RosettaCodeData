import scala.annotation.tailrec

object BabbageProblem {

  @tailrec
  def findItFrom(x: Int): Int =
    if ((x * x) % 1000000 == 269696) x
    else findItFrom(
      if (x % 10 == 4) x + 2
      else x + 8
    )

  def findIt: Int = findItFrom(524) // Sqrt of 269696 = 519.something

  def main(args: Array[String]): Unit =
    println("The smallest positive integer whose square ends in 269696 = " + findIt)

}
