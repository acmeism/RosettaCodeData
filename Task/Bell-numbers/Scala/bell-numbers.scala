import scala.collection.mutable.ListBuffer

object BellNumbers {
  class BellTriangle {
    val arr: ListBuffer[Int] = ListBuffer.empty[Int]

    def this(n: Int) {
      this()

      val length = n * (n + 1) / 2
      for (_ <- 0 until length) {
        arr += 0
      }

      this (1, 0) = 1
      for (i <- 2 to n) {
        this (i, 0) = this (i - 1, i - 2)
        for (j <- 1 until i) {
          this (i, j) = this (i, j - 1) + this (i - 1, j - 1)
        }
      }
    }

    private def index(row: Int, col: Int): Int = {
      require(row > 0, "row must be greater than zero")
      require(col >= 0, "col must not be negative")
      require(col < row, "col must be less than row")

      row * (row - 1) / 2 + col
    }

    def apply(row: Int, col: Int): Int = {
      val i = index(row, col)
      arr(i)
    }

    def update(row: Int, col: Int, value: Int): Unit = {
      val i = index(row, col)
      arr(i) = value
    }
  }

  def main(args: Array[String]): Unit = {
    val rows = 15
    val bt = new BellTriangle(rows)

    println("First fifteen Bell numbers:")
    for (i <- 0 until rows) {
      printf("%2d: %d\n", i + 1, bt(i + 1, 0))
    }

    for (i <- 1 to 10) {
      print(bt(i, 0))
      for (j <- 1 until i) {
        print(s", ${bt(i, j)}")
      }
      println()
    }
  }
}
