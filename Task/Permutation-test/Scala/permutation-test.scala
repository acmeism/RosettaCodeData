object PermutationTest extends App {
  private val data =
    Array(85, 88, 75, 66, 25, 29, 83, 39, 97, 68, 41, 10, 49, 16, 65, 32, 92, 28, 98)
  private var (total, treat) = (1.0, 0)

  private def pick(at: Int, remain: Int, accu: Int, treat: Int): Int = {
    if (remain == 0) return if (accu > treat) 1 else 0

    pick(at - 1, remain - 1, accu + data(at - 1), treat) +
      (if (at > remain) pick(at - 1, remain, accu, treat) else 0)
  }

  for (i <- 0 to 8) treat += data(i)
  for (j <- 19 to 11 by -1) total *= j
  for (g <- 9 to 1 by -1) total /= g

  private val gt = pick(19, 9, 0, treat)
  private val le = (total - gt).toInt

  println(f"<= : ${100.0 * le / total}%f%%  ${le}%d")
  println(f" > : ${100.0 * gt / total}%f%%  ${gt}%d")

}
