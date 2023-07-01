object Ludic {
  def main(args: Array[String]): Unit = {
    println(
      s"""|First 25 Ludic Numbers: ${ludic.take(25).mkString(", ")}
          |Ludic Numbers <= 1000: ${ludic.takeWhile(_ <= 1000).size}
          |2000-2005th Ludic Numbers: ${ludic.slice(1999, 2005).mkString(", ")}
          |Triplets <= 250: ${triplets.takeWhile(_._3 <= 250).mkString(", ")}""".stripMargin)
  }

  def dropByN[T](lst: LazyList[T], len: Int): LazyList[T] = lst.grouped(len).flatMap(_.init).to(LazyList)
  def ludic: LazyList[Int] = 1 #:: LazyList.unfold(LazyList.from(2)){case n +: ns => Some((n, dropByN(ns, n)))}
  def triplets: LazyList[(Int, Int, Int)] = LazyList.from(1).map(n => (n, n + 2, n + 6)).filter{case (a, b, c) => Seq(a, b, c).forall(ludic.takeWhile(_ <= c).contains)}
}
