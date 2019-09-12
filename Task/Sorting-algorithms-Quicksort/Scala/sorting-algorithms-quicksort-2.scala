  def sort[T](xs: List[T], lessThan: (T, T) => Boolean): List[T] = xs match {
    case Nil => Nil
    case x :: xx =>
      val (lo, hi) = xx.partition(lessThan(_, x))
      sort(lo, lessThan) ++ (x :: sort(hi, lessThan))
  }
