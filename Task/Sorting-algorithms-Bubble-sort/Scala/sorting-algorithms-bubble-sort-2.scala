import scala.annotation.tailrec

def bubbleSort(xt: List[Int]) = {
  @tailrec
  def bubble(xs: List[Int], rest: List[Int], sorted: List[Int]): List[Int] = xs match {
    case x :: Nil =>
      if (rest.isEmpty) x :: sorted
      else bubble(rest, Nil, x :: sorted)
    case a :: b :: xs =>
      if (a > b) bubble(a :: xs, b :: rest, sorted)
      else       bubble(b :: xs, a :: rest, sorted)
  }
  bubble(xt, Nil, Nil)
}
