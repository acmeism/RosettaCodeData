object LongestIncreasingSubsequence extends App {
  def longest(l: Array[Int]) = l match {
    case _ if l.length < 2 => Array(l)
    case l =>
      def increasing(done: Array[Int], remaining: Array[Int]): Array[Array[Int]] = remaining match {
        case Array() => Array(done)
        case Array(head, _*) =>
          (if (head > done.last) increasing(done :+ head, remaining.tail) else Array()) ++
          increasing(done, remaining.tail) // all increasing combinations
      }
      val all = (1 to l.length).flatMap(i => increasing(l take i takeRight 1, l.drop(i+1))).sortBy(-_.length)
      all.takeWhile(_.length == all.head.length).toArray // longest from all increasing combinations
  }

  val tests = Map(
    "3,2,6,4,5,1" -> Array("2,4,5", "3,4,5"),
    "0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15" -> Array("0,2,6,9,11,15", "0,2,6,9,13,15", "0,4,6,9,13,15", "0,4,6,9,11,15")
  )
  def asInts(s: String): Array[Int] = s split "," map Integer.parseInt
  assert(tests forall {case (given, expect) =>
      val lis = longest(asInts(given))
      println(s"$given has ${lis.size} longest increasing subsequences, e.g. "+lis.last.mkString(","))
      expect contains lis.last.mkString(",")
  })
}
