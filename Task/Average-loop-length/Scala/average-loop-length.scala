import scala.util.Random

object AverageLoopLength extends App {

  val factorial: Stream[Double] = 1 #:: factorial.zip(Stream.from(1)).map(n => n._2 * factorial(n._2 - 1))

  def expected(n: Int) = (for (i <- 1 to n) yield factorial(n) / Math.pow(n, i) / factorial(n - i)).sum

  def trial(n: Int):Double = {
    var count = 0
    var x = 1
    var bits = 0

    while ((bits & x) == 0) {
      count = count + 1
      bits = bits | x
      x = 1 << Random.nextInt(n)
    }
    count
  }

  def tested(n: Int, times: Int) = (for (i <- 1 to times) yield trial(n)).sum / times

  val results = for (n <- 1 to 20;
                     avg = tested(n, 1000000);
                     theory = expected(n)
  ) yield (n, avg, theory, (avg / theory - 1) * 100)


  println("n          avg         exp      diff")
  println("------------------------------------")
  results foreach { n => {
      println(f"${n._1}%2d    ${n._2}%2.6f    ${n._3}%2.6f    ${n._4}%2.3f%%")
    }
  }

}
