object FareySequence {

  def fareySequence(n: Int, start: (Int, Int), stop: (Int, Int)): LazyList[(Int, Int)] = {
    val (nominator_l, denominator_l) = start
    val (nominator_r, denominator_r) = stop

    val mediant = ((nominator_l + nominator_r), (denominator_l + denominator_r))

    if (mediant._2 <= n) fareySequence(n, start, mediant) ++ mediant #:: fareySequence(n, mediant, stop)
    else LazyList.empty
  }

  def farey(n: Int, start: (Int, Int) = (0, 1), stop: (Int, Int) = (1, 1)): LazyList[(Int, Int)] = {
    start #:: fareySequence(n, start, stop) ++ stop #:: LazyList.empty[(Int, Int)]
  }

  def main(args: Array[String]): Unit = {
    for (i <- 1 to 11) {
      println(s"$i: " + farey(i).map(e => s"${e._1}/${e._2}").mkString(", "))
    }
    println
    for (i <- 100 to 1000 by 100) {
      println(s"$i: " + farey(i).length + " elements")
    }
  }

}
