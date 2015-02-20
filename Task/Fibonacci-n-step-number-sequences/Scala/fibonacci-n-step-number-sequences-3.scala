//instead of summing k elements each phase, we exploit the fact
//that the last element is already the sum of all k preceding elements
def fib2Stream(init: BigInt*): Stream[BigInt] = {
  def inner(prev: Vector[BigInt]): Stream[BigInt] = {
    val n = prev.last * 2 - prev.head
    n #:: inner(prev.tail :+ n)
  }
  //last element must be the sum of k preceding elements, vector size should be k+1
  val v = init.toVector :+ init.sum
  v.toStream #::: inner(v)
}
