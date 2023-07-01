import scala.io.{Source, StdIn}

def fizzBuzzTerm(n: Int, factors: Seq[(Int, String)]): String | Int =
  val words = factors.collect { case (k, v) if n % k == 0 => v }
  if words.nonEmpty then words.mkString else n

def fizzBuzz(factors: Seq[(Int, String)]): LazyList[String | Int] =
  LazyList.from(1).map(i => fizzBuzzTerm(i, factors))

@main def run(): Unit =
  val max = StdIn.readInt()
  val factors: Seq[(Int, String)] = Source.stdin.getLines().toSeq
    .map(_.split(" ", 2))
    .map { case Array(k, v) => k.toInt -> v }
    .sorted
  fizzBuzz(factors).take(max).foreach(println)
