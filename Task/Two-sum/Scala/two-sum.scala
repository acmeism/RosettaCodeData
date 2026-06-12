import java.util

object TwoSum extends App {
  val (sum, arr)= (21, Array(0, 2, 11, 19, 90))
  println(util.Arrays.toString(twoSum(arr, sum)))

  private def twoSum(a: Array[Int], target: Long): Array[Int] = {
    var (i, j) = (0, a.length - 1)
    while (i < j) {
      val sum = a(i) + a(j)
      if (sum == target) return Array[Int](i, j)
      if (sum < target) i += 1 else j -= 1
    }
    null
  }

}
