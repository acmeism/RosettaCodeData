object KDTreeTest extends App {
  def test[T](haystack: Seq[Seq[T]], needles: Seq[T]*)(implicit num: Numeric[T]) = {
    println
    val tree = KDTree(haystack)
    if (haystack.size < 20) tree.foreach(println)
    for (kd <- tree; needle <- needles; nearest = kd nearest needle) {
      println(nearest)
      // Brute force proof
      val better = haystack
        .map(KDTree.Nearest(_, needle))
        .filter(n => num.lt(n.distsq, nearest.distsq))
        .sortBy(_.distsq)
      assert(better.isEmpty, s"Found ${better.size} closer than ${nearest.value} e.g. ${better.head}")
    }
  }

  // Results 1
  val wikitest = List(List(2,3), List(5,4), List(9,6), List(4,7), List(8,1), List(7,2))
  test(wikitest, List(9,2))

  // Results 2 (1000 points uniformly distributed in 3-d cube coordinates, sides 2 to 20)
  val uniform = for(x <- 1 to 10; y <- 1 to 10; z <- 1 to 10) yield List(x*2, y*2, z*2)
  assume(uniform.size == 1000)
  test(uniform, List(0, 0, 0), List(2, 2, 20), List(9, 10, 11))

  // Results 3 (1000 points randomly distributed in 3-d cube coordinates, sides -1.0 to 1.0)
  scala.util.Random.setSeed(0)
  def random(n: Int) = (1 to n).map(_ => (scala.util.Random.nextDouble - 0.5)* 2)
  test((1 to 1000).map(_ => random(3)), random(3))

  // Results 4 (27 points uniformly distributed in 3-d cube coordinates, sides 3...9)
  val small = for(x <- 1 to 3; y <- 1 to 3; z <- 1 to 3) yield List(x*3, y*3, z*3)
  assume(small.size == 27)
  test(small, List(0, 0, 0), List(4, 5, 6))
}
