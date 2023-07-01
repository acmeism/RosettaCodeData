import scala.io.{Source, StdIn}

object GeneralFizzBuzz extends App {
  def fizzBuzzTerm(n: Int, factors: Seq[(Int, String)]): String = {
    val words = factors.collect { case (k, v) if n % k == 0 => v }
    if (words.nonEmpty) words.mkString else n.toString
  }

  def fizzBuzz(factors: Seq[(Int, String)]): LazyList[String] =
    LazyList.from(1).map(fizzBuzzTerm(_, factors))

  val max = StdIn.readInt()
  val factors = Source.stdin.getLines().toSeq
    .map(_.split(" ", 2))
    .map { case Array(k, v) => k.toInt -> v }
    .sorted
  fizzBuzz(factors).take(max).foreach(println)
}
