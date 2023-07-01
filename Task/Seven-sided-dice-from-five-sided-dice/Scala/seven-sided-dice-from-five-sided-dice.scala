import scala.util.Random

object SevenSidedDice extends App {
  private val rnd = new Random

  private def seven = {
    var v = 21

    def five = 1 + rnd.nextInt(5)

    while (v > 20) v = five + five * 5 - 6
    1 + v % 7
  }

  println("Random number from 1 to 7: " + seven)

}
