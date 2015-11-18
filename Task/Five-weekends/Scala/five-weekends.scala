import java.util.Calendar._
import java.util.GregorianCalendar

import org.scalatest.{FlatSpec, Matchers}

class FiveWeekends extends FlatSpec with Matchers {

  case class YearMonth[T](year: T, month: T)
  implicit class CartesianProd[T](val seq: Seq[T]) {
    def x(other: Seq[T]) = for(s1 <- seq; s2 <- other) yield YearMonth(year=s1,month=s2)
    def -(other: Seq[T]): Seq[T] = seq diff other
  }

  def has5weekends(ym: { val year: Int; val month: Int}) = {
    val date = new GregorianCalendar(ym.year, ym.month-1, 1)
    date.get(DAY_OF_WEEK) == FRIDAY && date.getActualMaximum(DAY_OF_MONTH) == 31
  }

  val expectedFirstFive = Seq(
    YearMonth(1901,3), YearMonth(1902,8), YearMonth(1903,5), YearMonth(1904,1), YearMonth(1904,7))
  val expectedFinalFive = Seq(
    YearMonth(2097,3), YearMonth(2098,8), YearMonth(2099,5), YearMonth(2100,1), YearMonth(2100,10))
  val expectedNon5erYears = Seq(1900, 1906, 1917, 1923, 1928, 1934, 1945, 1951, 1956, 1962,
                                1973, 1979, 1984, 1990, 2001, 2007, 2012, 2018, 2029, 2035,
                                2040, 2046, 2057, 2063, 2068, 2074, 2085, 2091, 2096)

  "Five Weekend Algorithm" should "match specification" in {
    val months = (1900 to 2100) x (1 to 12) filter has5weekends
    months.size shouldBe 201
    months.take(5) shouldBe expectedFirstFive
    months.takeRight(5) shouldBe expectedFinalFive

    (1900 to 2100) - months.map(_.year) shouldBe expectedNon5erYears
  }
}
