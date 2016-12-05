  def sort[T](xs: List[T])(implicit ord: Ordering[T]): List[T] = {
    xs match {
      case Nil => Nil
      case x :: xx => {
        val (lo, hi) = xx.partition(ord.lt(_, x))
        sort[T](lo) ++ (x :: sort[T](hi))
      }
    }
  }
