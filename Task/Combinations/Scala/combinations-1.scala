implicit def toComb(m: Int) = new AnyRef {
  def comb(n: Int) = recurse(m, List.range(0, n))
  private def recurse(m: Int, l: List[Int]): List[List[Int]] = (m, l) match {
    case (0, _)   => List(Nil)
    case (_, Nil) => Nil
    case _        => (recurse(m - 1, l.tail) map (l.head :: _)) ::: recurse(m, l.tail)
  }
}
