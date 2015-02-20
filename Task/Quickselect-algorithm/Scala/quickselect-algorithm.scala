import scala.util.Random

object QuickSelect {
  def quickSelect[A <% Ordered[A]](seq: Seq[A], n: Int, rand: Random = new Random): A = {
    val pivot = rand.nextInt(seq.length);
    val (left, right) = seq.partition(_ < seq(pivot))
    if (left.length == n) {
      seq(pivot)
    } else if (left.length < n) {
      quickSelect(right, n - left.length, rand)
    } else {
      quickSelect(left, n, rand)
    }
  }

  def main(args: Array[String]): Unit = {
    val v = Array(9, 8, 7, 6, 5, 0, 1, 2, 3, 4)
    println((0 until v.length).map(quickSelect(v, _)).mkString(", "))
  }
}
