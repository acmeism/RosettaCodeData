//in the optimized version we don't compute values until it's needed.
//the unoptimized version, computed k elements ahead, where k being
//the number of elements to sum (fibonacci: k=2, tribonacci: k=3, ...).
def fibStream(init: BigInt*): Stream[BigInt] = {
  def inner(prev: Vector[BigInt]): Stream[BigInt] = {
    val sum = prev.sum
    sum #:: inner(prev.tail :+ sum)
  }
  init.toStream #::: inner(init.toVector)
}
