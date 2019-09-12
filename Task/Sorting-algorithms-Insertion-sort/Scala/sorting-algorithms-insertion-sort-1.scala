def insertSort[X](list: List[X])(implicit ord: Ordering[X]) = {
  def insert(list: List[X], value: X) = list.span(x => ord.lt(x, value)) match {
    case (lower, upper) => lower ::: value :: upper
  }
  list.foldLeft(List.empty[X])(insert)
}
