import java.lang.Long.bitCount

object PopCount extends App {
  val nNumber = 30

  def powersThree(start: Long): LazyList[Long] = start #:: powersThree(start * 3L)

  println("Population count of 3ⁿ :")
  println(powersThree(1L).map(bitCount).take(nNumber).mkString(", "))

  def series(start: Long): LazyList[Long] = start #:: series(start + 1L)

  println("Evil numbers:")
  println(series(0L).filter(bitCount(_) % 2 == 0).take(nNumber).mkString(", "))

  println("Odious numbers:")
  println(series(0L).filter(bitCount(_) % 2 != 0).take(nNumber).mkString(", "))

}
