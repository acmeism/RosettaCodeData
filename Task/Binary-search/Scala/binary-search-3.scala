def testBinarySearch(n: Int) = {
  val odds = 1 to n by 2
  val result = (0 to n).flatMap(binarySearch(odds, _))
  assert(result == (0 until odds.size))
  println(s"$odds are odd natural numbers")
  for (it <- result)
    println(s"$it is ordinal of ${odds(it)}")
}

def main() = testBinarySearch(12)
