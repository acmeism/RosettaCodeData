def powerset[A](s: Set[A]) = {
  def powerset_rec(acc: List[Set[A]], remaining: List[A]): List[Set[A]] = remaining match {
    case Nil => acc
    case head :: tail => powerset_rec(acc ++ acc.map(_ + head), tail)
  }
  powerset_rec(List(Set.empty[A]), s.toList)
}
