def mergeSort(input: List[Int]) = {
  def merge(left: List[Int], right: List[Int]): Stream[Int] = (left, right) match {
    case (x :: xs, y :: ys) if x <= y => x #:: merge(xs, right)
    case (x :: xs, y :: ys) => y #:: merge(left, ys)
    case _ => if (left.isEmpty) right.toStream else left.toStream
  }
  def sort(input: List[Int], length: Int): List[Int] = input match {
    case Nil | List(_) => input
    case _ =>
      val middle = length / 2
      val (left, right) = input splitAt middle
      merge(sort(left, middle), sort(right, middle + length % 2)).toList
  }
  sort(input, input.length)
}
