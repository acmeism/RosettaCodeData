  def sort(xs: List[Int]): List[Int] = xs match {
    case Nil => Nil
    case head :: tail =>
      val (less, notLess) = tail.partition(_ < head) // Arbitrarily partition list in two
      sort(less) ++ (head :: sort(notLess))          // Sort each half
  }
