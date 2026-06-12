object IOPairs extends App {
  private val in = scala.io.StdIn
  private val n = in.readInt()

  for (_ <- 0 until n) {
    val Array(a, b) = in.readLine().split(" ").map(_.toInt)

    def doStuff(a: Long, b: Long): Long = a + b

    println(doStuff(a, b))
  }

}
