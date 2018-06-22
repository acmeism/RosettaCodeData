object Main extends App {

  def lookAndSay(previous: List[BigInt]): Stream[List[BigInt]] = {

    def next(num: List[BigInt]): List[BigInt] = num match {
      case Nil => Nil
      case head :: Nil => 1 :: head :: Nil
      case head :: tail =>
        val size = (num takeWhile (_ == head)).size
        List(BigInt(size), head) ::: next(num.drop(size))
    }
    val x = next(previous)
    x #:: lookAndSay(x)
  }

  (lookAndSay(1 :: Nil) take 10).foreach(s => println(s.mkString("")))
}
