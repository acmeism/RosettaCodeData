import java.time.{ DayOfWeek, LocalDate }
import scala.annotation.tailrec

object DayOfTheWeek3 extends App {
  val years = 2008 to 2121
  val yuletide = {
    @tailrec
    def inner(anni: List[Int], accu: List[Int]): List[Int] = {
      if (anni == Nil) accu
      else inner(anni.tail, accu ++
        (if (LocalDate.of(anni.head, 12, 25).getDayOfWeek() == DayOfWeek.SUNDAY)
          List(anni.head) else Nil))
    }
    inner(years.toList, Nil)
  }

  println(yuletide.mkString(
    s"${yuletide.count(p => true)} Years between ${years.head} and ${years.last}" +
      " including where Christmas is observed on Sunday:\n", ", ", "."))
}
