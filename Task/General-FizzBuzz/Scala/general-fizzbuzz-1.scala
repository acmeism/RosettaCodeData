import scala.io.{Source, StdIn}

object GeneralFizzBuzz extends App {
  val max = StdIn.readInt()
  val factors = Source.stdin.getLines().toSeq
    .map(_.split(" ", 2))
    .map(f => f(0).toInt -> f(1))
    .sorted

  (1 to max).foreach { i =>
    val words = factors.collect { case (k, v) if i % k == 0 => v }
    println(if (words.nonEmpty) words.mkString else i)
  }
}
