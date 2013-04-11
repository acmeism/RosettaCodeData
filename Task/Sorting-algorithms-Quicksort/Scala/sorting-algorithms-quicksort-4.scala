def quicksort
  [T, CC[X] <: Seq[X] with SeqLike[X, CC[X]]]       // My type parameters
  (coll: CC[T])                                                     // My explicit parameter
  (implicit o: T => Ordered[T], cbf: CanBuildFrom[CC[T], T, CC[T]]) // My implicit parameters
  : CC[T] =                                                         // My return type
  if (coll.isEmpty) {
    coll
  } else {
    val (smaller, bigger) = coll.tail partition (_ < coll.head)
    quicksort(smaller) ++ (coll.head +: quicksort(bigger))
  }
