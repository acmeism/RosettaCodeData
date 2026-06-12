object FindFirstMissingPositive

def firstMissingPositive(nums: List[Int]): Int =
  val positive = nums.filter(_ > 0)
  (1 to positive.max + 1).diff(positive).head

@main def main(): Unit =
  def test(nums: List[Int]): Unit =
    val result = firstMissingPositive(nums)
    val printableNums = nums.mkString("[", ", ", "]")
    println(s"$printableNums -> $result")

  List(
    List(1, 2, 0), List(3, 4, -1, 1), List(7, 8, 9, 11, 12)
  )
    .foreach(test)
