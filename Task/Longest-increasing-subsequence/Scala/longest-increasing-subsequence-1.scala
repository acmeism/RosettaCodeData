object LongestIncreasingSubsequence extends App {
  val tests = Map(
    "3,2,6,4,5,1" -> Seq("2,4,5", "3,4,5"),
    "0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15" -> Seq("0,2,6,9,11,15", "0,2,6,9,13,15", "0,4,6,9,13,15", "0,4,6,9,11,15")
  )

  def lis(l: Array[Int]): Seq[Array[Int]] =
    if (l.length < 2) Seq(l)
    else {
      def increasing(done: Array[Int], remaining: Array[Int]): Seq[Array[Int]] =
        if (remaining.isEmpty) Seq(done)
        else
          (if (remaining.head > done.last)
            increasing(done :+ remaining.head, remaining.tail)
          else Nil) ++ increasing(done, remaining.tail) // all increasing combinations

      val all = (1 to l.length)
        .flatMap(i => increasing(l take i takeRight 1, l.drop(i + 1)))
        .sortBy(-_.length)
      all.takeWhile(_.length == all.head.length) // longest of all increasing combinations
    }

  def asInts(s: String): Array[Int] = s split "," map (_.toInt)

  assert(tests forall {
    case (given, expect) =>
      val allLongests: Seq[Array[Int]] = lis(asInts(given))
      println(
        s"$given has ${allLongests.length} longest increasing subsequences, e.g. ${
          allLongests.last.mkString(",")}")
      allLongests.forall(lis => expect.contains(lis.mkString(",")))
  })
}
