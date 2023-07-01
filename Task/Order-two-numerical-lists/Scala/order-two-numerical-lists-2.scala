def lessThan2(a: List[Int], b: List[Int]): Boolean = (a, b) match {
  case (_, Nil) => false
  case (Nil, _) => true
  case (a :: _, b :: _) if a != b => a < b
  case _ => lessThan2(a.tail, b.tail)
}
