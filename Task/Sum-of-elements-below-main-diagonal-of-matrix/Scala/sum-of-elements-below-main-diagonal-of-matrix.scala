object Main {
  def main(args: Array[String]): Unit = {
    val matrix = Array(
      Array(1, 3, 7, 8, 10),
      Array(2, 4, 16, 14, 4),
      Array(3, 1, 9, 18, 11),
      Array(12, 14, 17, 18, 20),
      Array(7, 1, 3, 9, 5)
    )
    var sum = 0
    for (row <- 1 until matrix.length) {
      for (col <- 0 until row) {
        sum += matrix(row)(col)
      }
    }
    println(sum)
  }
}
