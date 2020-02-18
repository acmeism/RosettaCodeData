import scala.util.Random

object AverageLoopLength extends App {

  val factorial: LazyList[Double] = 1 #:: factorial.zip(LazyList.from(1)).map(n => n._2 * factorial(n._2 - 1))
  val results = for (n <- 1 to 20;
                     avg = tested(n, 1000000);
                     theory = expected(n)
                     ) yield (n, avg, theory, (avg / theory - 1) * 100)

  def expected(n: Int): Double = (for (i <- 1 to n) yield factorial(n) / Math.pow(n, i) / factorial(n - i)).sum

  def tested(n: Int, times: Int): Double = (for (i <- 1 to times) yield trial(n)).sum / times

  def trial(n: Int): Double = {
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


  println("n          avg         exp      diff")
  println("------------------------------------")
  results foreach { n => {
    println(f"${n._1}%2d    ${n._2}%2.6f    ${n._3}%2.6f    ${n._4}%2.3f%%")
  }
  }

}
