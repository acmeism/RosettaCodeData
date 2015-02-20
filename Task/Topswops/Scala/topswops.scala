object Fannkuch extends App {

  def fannkuchen(l: List[Int], n: Int, i: Int, acc: Int): Int = {
    def flips(l: List[Int]): Int = (l: @unchecked) match {
      case 1 :: ls => 0
      case (n :: ls) =>
        val splitted = l.splitAt(n)
        flips(splitted._2.reverse_:::(splitted._1)) + 1
    }

    def rotateLeft(l: List[Int]) =
      l match {
        case Nil => List()
        case x :: xs => xs ::: List(x)
      }

    if (i >= n) acc
    else {
      if (n == 1) acc.max(flips(l))
      else {
        val split = l.splitAt(n)
        fannkuchen(rotateLeft(split._1) ::: split._2, n, i + 1, fannkuchen(l, n - 1, 0, acc))
      }
    }
  } // def fannkuchen(

  val result = (1 to 10).map(i => (i, fannkuchen(List.range(1, i + 1), i, 0, 0)))
  println("Computing results...")
  result.foreach(x => println(s"Pfannkuchen(${x._1})\t= ${x._2}"))
  assert(result == Vector((1, 0), (2, 1), (3, 2), (4, 4), (5, 7), (6, 10), (7, 16), (8, 22), (9, 30), (10, 38)), "Bad results")
  println(s"Successfully completed without errors. [total ${scala.compat.Platform.currentTime - executionStart} ms]")
}
