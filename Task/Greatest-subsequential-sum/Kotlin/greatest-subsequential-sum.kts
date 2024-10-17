// version 1.1

fun gss(seq: IntArray): Triple<Int, Int, Int> {
    if (seq.isEmpty()) throw IllegalArgumentException("Array cannot be empty")
    var sum: Int
    var maxSum = seq[0]
    var first = 0
    var last = 0
    for (i in 1 until seq.size) {
        sum = 0
        for (j in i until seq.size) {
            sum += seq[j]
            if (sum > maxSum) {
                maxSum = sum
                first = i
                last = j
            }
        }
    }
    return Triple(maxSum, first, last)
}

fun main(args: Array<String>) {
  val seq = intArrayOf(-1 , -2 , 3 , 5 , 6 , -2 , -1 , 4 , -4 , 2 , -1)
  val(maxSum, first, last) = gss(seq)
  if (maxSum > 0) {
      println("Maximum subsequence is from indices $first to $last")
      print("Elements are : ")
      for (i in first .. last) print("${seq[i]} ")
      println("\nSum is $maxSum")
  }
  else
      println("Maximum subsequence is the empty sequence which has a sum of 0")
}
