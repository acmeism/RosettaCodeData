def lessThan1(a: List[Int], b: List[Int]): Boolean =
  if (b.isEmpty) false
  else if (a.isEmpty) true
  else if (a.head != b.head) a.head < b.head
  else lessThan1(a.tail, b.tail)
