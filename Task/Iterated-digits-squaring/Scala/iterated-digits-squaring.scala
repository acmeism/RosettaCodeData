import scala.annotation.tailrec

object Euler92 extends App {
  override val executionStart = compat.Platform.currentTime

  @tailrec
  private def calcRec(i: Int): Int = {

    @tailrec
    def iter0(n: Int, total: Int): Int =
      if (n > 0) {
        val rest = n % 10
        iter0(n / 10, total + rest * rest)
      }
      else total


    if (i == 89 || i == 1) i else calcRec(iter0(i, 0))
  }


  private def calcConv(i: Int) = {
    var n: Int = i
    while (n != 89 && n != 1) {
      var total = 0
      while (n > 0) {
        val x = n % 10
        total += (x * x)
        n /= 10
      }
      n = total
    }
    n
  }

  println((1 until 100000000).par.count(calcConv(_) == 89))
  println(s"Runtime conventional loop.[total ${compat.Platform.currentTime - executionStart} ms]")

  val executionStart0 = compat.Platform.currentTime
  println((1 until 100000000).par.count(calcRec(_) == 89))
  println(s"Runtime recursive loop.   [total ${compat.Platform.currentTime - executionStart0} ms]")

}
