def lessThan3(a: List[Int], b: List[Int]): Boolean =
  a.zipAll(b, Integer.MIN_VALUE, Integer.MIN_VALUE)
   .find{case (a, b) => a != b}
   .map{case (a, b) => a < b}
   .getOrElse(false)
