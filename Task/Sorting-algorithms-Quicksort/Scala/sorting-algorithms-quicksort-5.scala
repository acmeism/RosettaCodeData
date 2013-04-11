def quicksortInt(list: List[Int]): List[Int] = list match {
    case head :: tail =>
      val (smaller, bigger) = tail partition (_ < head)
      quicksortInt(smaller) ::: head :: quicksortInt(bigger)
    case list => list
  }
