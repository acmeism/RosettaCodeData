  //we rely on implicit conversion from Int to BigInt.
  //BigInt is preferable since the numbers get very big, very fast.
  //(though for a small example of the first few numbers it's not needed)
  def fibStream(init: BigInt*): LazyList[BigInt] = {
    def inner(prev: Vector[BigInt]): LazyList[BigInt] = prev.head #:: inner(prev.tail :+ prev.sum)

    inner(init.toVector)
  }
