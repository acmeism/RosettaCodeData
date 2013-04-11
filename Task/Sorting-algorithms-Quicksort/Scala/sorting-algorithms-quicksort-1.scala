def quicksortInt(coll: List[Int]): List[Int] =
  if (coll.isEmpty) {
    coll
  } else {
    val (smaller, bigger) = coll.tail partition (_ < coll.head)
    quicksortInt(smaller) ::: coll.head :: quicksortInt(bigger)
  }
