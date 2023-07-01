object Repeat2 extends App {

   implicit class IntWithTimes(x: Int) {
      def times[A](f: => A):Unit = {
    @tailrec
      def loop( current: Int): Unit =
        if (current > 0) {
          f
          loop(current - 1)
        }
      loop(x)
    }
  }

  5 times println("ha") // Not recommended infix for 5.times(println("ha")) aka dot notation
}
