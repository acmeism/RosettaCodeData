import java.time.{ DayOfWeek, LocalDate }
import scala.annotation.tailrec

object DayOfTheWeek3 extends App {
  val years = 2008 to 2121
  val yuletide = {
    @tailrec
    def inner(anni: List[Int], accu: List[Int]): List[Int] = {
      if (anni == Nil) accu
      else inner(anni.tail, accu ++
        (if (LocalDate.of(anni.head, 12, 25).getDayOfWeek() == DayOfWeek.SUNDAY) List(anni.head)
        else Nil))
    }
    inner(years.toList, Nil)
  }

  // If you want a test: (optional)
  assert(yuletide ==
    Seq(2011, 2016, 2022, 2033, 2039, 2044, 2050, 2061,
      2067, 2072, 2078, 2089, 2095, 2101, 2107, 2112, 2118))

  println(yuletide.mkString(
    s"${yuletide.length} Years between ${years.head} and ${years.last}" +
      " including where Christmas is observed on Sunday:\n", ", ", "."))
}
