object LuhnTest extends App {

  object Luhn {

    // pre calculate even digits
    private val evenDigits = Vector(0, 2, 4, 6, 8, 1, 3, 5, 7, 9)

    private def compute(number: String): Int = {
      number.foreach(d => require(d >= '0' && d <= '9', "must be a number"))

      // we don't need to process the number in reverse because we determine if the digit is in a even position or not
      number.foldLeft((number.length & 1) == 0, 0) { (sum, d) =>
        if (sum._1) (!sum._1, sum._2 + evenDigits(d - '0'))
        else (!sum._1, sum._2 + d - '0')
      }._2
    }

    // Validate a number using Luhn checksum
    def validate(number: String): Boolean = compute(number) % 10 == 0

    // Compute check digit using Luhn (not used for this task)
    def computeCheckDigit(number: String): Int = {
      compute(number + '0') % 10 match {
        case 0 => 0
        case x => 10 - x
      }
    }
  }

  val numbers = Seq("49927398716", "49927398717", "1234567812345678", "1234567812345670")

  numbers.foreach { n =>
    println(s"$n ${Luhn.validate(n)}")
  }
}
