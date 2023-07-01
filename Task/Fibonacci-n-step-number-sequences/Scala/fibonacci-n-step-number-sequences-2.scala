  //in the optimized version we don't compute values until it's needed.
  //the unoptimized version, computed k elements ahead, where k being
  //the number of elements to sum (fibonacci: k=2, tribonacci: k=3, ...).
  def fib2Stream(init: BigInt*): LazyList[BigInt] = {
    def inner(prev: Vector[BigInt]): LazyList[BigInt] = {
      val sum = prev.sum
      sum #:: inner(prev.tail :+ sum)
    }

    init.to(LazyList) #::: inner(init.toVector)
  }
