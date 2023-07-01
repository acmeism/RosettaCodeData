val tests = List(
  (List(1, 2, 3), List(1, 2, 3)) -> false,
  (List(3, 2, 1), List(3, 2, 1)) -> false,
  (List(1, 2, 3), List(3, 2, 1)) -> true,
  (List(3, 2, 1), List(1, 2, 3)) -> false,
  (List(1, 2), List(1, 2, 3)) -> true,
  (List(1, 2, 3), List(1, 2)) -> false
)

tests.foreach{case test @ ((a, b), c) =>
  assert(lessThan1(a, b) == c, test)
  assert(lessThan2(a, b) == c, test)
  assert(lessThan3(a, b) == c, test)
}
