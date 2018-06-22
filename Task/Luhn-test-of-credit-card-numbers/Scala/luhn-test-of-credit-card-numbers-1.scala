object Luhn {
  private def parse(s: String): Seq[Int] = s.map{c =>
    assert(c.isDigit)
    c.asDigit
  }
  def checksum(digits: Seq[Int]): Int = {
    digits.reverse.zipWithIndex.foldLeft(0){case (sum,(digit,i))=>
      if (i%2 == 0) sum + digit
      else sum + (digit*2)/10 + (digit*2)%10
    } % 10
  }
  def validate(digits: Seq[Int]): Boolean = checksum(digits) == 0
  def checksum(number: String): Int = checksum(parse(number))
  def validate(number: String): Boolean = validate(parse(number))
}

object LuhnTest extends App {
  Seq(("49927398716", true),
    ("49927398717", false),
    ("1234567812345678", false),
    ("1234567812345670", true)
  ).foreach { case (n, expected) =>
    println(s"$n ${Luhn.validate(n)}")
    assert(Luhn.validate(n) == expected)
  }
}
