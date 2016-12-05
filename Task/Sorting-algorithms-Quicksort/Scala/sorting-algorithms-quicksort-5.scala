  def sort[T, C[T] <: scala.collection.TraversableLike[T, C[T]]]
    (xs: C[T])
    (implicit ord: scala.math.Ordering[T],
      cbf: scala.collection.generic.CanBuildFrom[C[T], T, C[T]]): C[T] = {
    // Some collection types can't pattern match
    if (xs.isEmpty) {
      xs
    } else {
      val (lo, hi) = xs.tail.partition(ord.lt(_, xs.head))
      val b = cbf()
      b.sizeHint(xs.size)
      b ++= sort(lo)
      b += xs.head
      b ++= sort(hi)
      b.result()
    }
  }
