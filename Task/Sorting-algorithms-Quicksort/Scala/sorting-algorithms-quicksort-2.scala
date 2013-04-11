def quicksortFunc[T](coll: List[T], lessThan: (T, T) => Boolean): List[T] =
  if (coll.isEmpty) {
    coll
  } else {
    val (smaller, bigger) = coll.tail partition (lessThan(_, coll.head))
    quicksortFunc(smaller, lessThan) ::: coll.head :: quicksortFunc(bigger, lessThan)
  }
