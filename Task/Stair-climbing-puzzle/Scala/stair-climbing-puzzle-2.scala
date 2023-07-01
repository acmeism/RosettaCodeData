def stepUp {
  def rec: List[Boolean] => Boolean = step :: (_: List[Boolean]) match {
    case true :: Nil => true
    case true :: false :: rest => rec(rest)
    case other => rec(other)
  }
  rec(Nil)
}
