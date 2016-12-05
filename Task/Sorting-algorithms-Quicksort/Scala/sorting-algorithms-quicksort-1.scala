  def sort(xs: List[Int]): List[Int] = {
    xs match {
      case Nil => Nil
      case x :: xx => {
        // Arbitrarily partition list in two
        val (lo, hi) = xx.partition(_ < x)
        // Sort each half
        sort(lo) ++ (x :: sort(hi))
      }
    }
  }
