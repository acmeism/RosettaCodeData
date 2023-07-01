def selectionSort[T <% Ordered[T]](list: List[T]): List[T] = {
  def remove(e: T, list: List[T]): List[T] =
    list match {
      case Nil => Nil
      case x :: xs if x == e => xs
      case x :: xs => x :: remove(e, xs)
    }

  list match {
    case Nil => Nil
    case _ =>
      val min = list.min
      min :: selectionSort(remove(min, list))
  }
}
