import scala.annotation.tailrec

object DammAlgorithm extends App {

  private val numbers = Seq(5724, 5727, 112946, 112949)

  @tailrec
  private def damm(s: String, interim: Int): String = {
    def table =
      Vector(
        Vector(0, 3, 1, 7, 5, 9, 8, 6, 4, 2),
        Vector(7, 0, 9, 2, 1, 5, 4, 8, 6, 3),
        Vector(4, 2, 0, 6, 8, 7, 1, 3, 5, 9),
        Vector(1, 7, 5, 0, 9, 8, 3, 4, 2, 6),
        Vector(6, 1, 2, 3, 0, 4, 5, 9, 7, 8),
        Vector(3, 6, 7, 4, 2, 0, 9, 5, 8, 1),
        Vector(5, 8, 6, 9, 7, 2, 0, 1, 3, 4),
        Vector(8, 9, 4, 5, 3, 6, 2, 0, 1, 7),
        Vector(9, 4, 3, 8, 6, 1, 7, 2, 0, 5),
        Vector(2, 5, 8, 1, 4, 3, 6, 7, 9, 0)
      )

    if (s.isEmpty) if (interim == 0) "✔" else "✘"
    else damm(s.tail, table(interim)(s.head - '0'))
  }

  for (number <- numbers) println(f"$number%6d is ${damm(number.toString, 0)}.")

}
