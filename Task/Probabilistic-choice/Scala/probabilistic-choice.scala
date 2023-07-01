object ProbabilisticChoice extends App {
  import scala.collection.mutable.LinkedHashMap

  def weightedProb[A](prob: LinkedHashMap[A,Double]): A = {
    require(prob.forall{case (_, p) => p > 0 && p < 1})
    assume(prob.values.sum == 1)
    def weighted(todo: Iterator[(A,Double)], rand: Double, accum: Double = 0): A = todo.next match {
      case (s, i) if rand < (accum + i) => s
      case (_, i) => weighted(todo, rand, accum + i)
    }
    weighted(prob.toIterator, scala.util.Random.nextDouble)
  }

  def weightedFreq[A](freq: LinkedHashMap[A,Int]): A = {
    require(freq.forall{case (_, f) => f >= 0})
    require(freq.values.sum > 0)
    def weighted(todo: Iterator[(A,Int)], rand: Int, accum: Int = 0): A = todo.next match {
      case (s, i) if rand < (accum + i) => s
      case (_, i) => weighted(todo, rand, accum + i)
    }
    weighted(freq.toIterator, scala.util.Random.nextInt(freq.values.sum))
  }

  // Tests:

  val probabilities = LinkedHashMap(
    'aleph  -> 1.0/5,
    'beth   -> 1.0/6,
    'gimel  -> 1.0/7,
    'daleth -> 1.0/8,
    'he     -> 1.0/9,
    'waw    -> 1.0/10,
    'zayin  -> 1.0/11,
    'heth   -> 1759.0/27720
  )

  val frequencies = LinkedHashMap(
    'aleph  -> 200,
    'beth   -> 167,
    'gimel  -> 143,
    'daleth -> 125,
    'he     -> 111,
    'waw    -> 100,
    'zayin  -> 91,
    'heth   -> 63
  )

  def check[A](original: LinkedHashMap[A,Double], results: Seq[A]) {
    val freq = results.groupBy(x => x).mapValues(_.size.toDouble/results.size)
    original.foreach{case (k, v) =>
      val a = v/original.values.sum
      val b = freq(k)
      val c = if (Math.abs(a - b) < 0.001) "ok" else "**"
      println(f"$k%10s  $a%.4f  $b%.4f  $c")
    }
    println(" "*10 + f"  ${1}%.4f  ${freq.values.sum}%.4f")
  }

  println("Checking weighted probabilities:")
  check(probabilities, for (i <- 1 to 1000000) yield weightedProb(probabilities))
  println
  println("Checking weighted frequencies:")
  check(frequencies.map{case (a, b) => a -> b.toDouble}, for (i <- 1 to 1000000) yield weightedFreq(frequencies))
}
