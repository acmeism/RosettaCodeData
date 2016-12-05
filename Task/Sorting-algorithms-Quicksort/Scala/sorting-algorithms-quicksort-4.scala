  def sort[T <: Ordered[T]](xs: List[T]): List[T] = {
    xs match {
      case Nil => Nil
      case x :: xx => {
        val (lo, hi) = xx.partition(_ < x)
        sort(lo) ++ (x :: sort(hi))
      }
    }
  }
