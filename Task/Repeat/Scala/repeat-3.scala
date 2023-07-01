import scala.annotation.tailrec

object Repeat3 extends App {

  implicit class UnitWithNtimes(f: => Unit) {
    def *[A](n: Int): Unit = { // Symbol * used instead of literal method name
      @tailrec
      def loop(current: Int): Unit =
        if (current > 0) {
          f
          loop(current - 1)
        }
      loop(n)
    }
  }

  print("ha") * 5 // * is the method, effective should be A.*(5)
}
