def quicksortOrd[T <% Ordered[T]](coll: List[T]): List[T] =
  if (coll.isEmpty) {
    coll
  } else {
    val (smaller, bigger) = coll.tail partition (_ < coll.head)
    quicksortOrd(smaller) ::: coll.head :: quicksortOrd(bigger)
  }
