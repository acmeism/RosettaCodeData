object LuhnTest extends App {
  def luhnTest1(number: String): Boolean = {
    var (odd, sum) = (true, 0)

    for (int <- number.reverse.map { _.toString.toShort }) {
      if (odd) sum += int else sum += (int * 2 % 10) + (int / 5)
      odd = !odd
    }
    sum % 10 == 0
  }

  def luhnChecksum(number: String) = { // This function can be used for Check digit generation
    (number.reverse.map { _.toString.toShort }.grouped(2) map
      { t => t(0) + (if (t.length > 1) (t(1) * 2) % 10 + t(1) / 5 else 0) }).sum % 10
  }

  // Bonus function Compute check digit and assemble it to a valid number
  def luhnWithComputedCheckDigit(partialCardNumber: String): String = {
    partialCardNumber +
      ((10 - luhnChecksum((partialCardNumber.toLong * 10).toString)) % 10).toString
  }

  val (validNumbers, invalidNumbers) =
    (List("49927398716", "1234567812345670"), List("49927398717", "1234567812345678"))

  // Valid number test
  assert(validNumbers.forall(x => luhnChecksum(x) == 0),
    "Correct number signaled as invalid")
  // Invalid number test
  assert(invalidNumbers.forall(x => luhnChecksum(x) != 0),
    "Incorrect number signaled as valid")

  // Test Check digit computation, reuse the valid and invalid numbers
  assert((validNumbers ++ invalidNumbers.
    map(s => luhnWithComputedCheckDigit(s.init /*make partial*/ ))).forall(x => luhnChecksum(x) == 0),
    "Error in computed checkdigit")

  print("Successfully completed without errors.")
}
