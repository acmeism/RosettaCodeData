object LuhnTest extends App {
  val (validNumbers, invalidNumbers) =
    (List("2621195162335", "49927398716", "1234567812345670", "4485284720134093"),
      List("49927398717", "1234567812345678"))

  // Bonus function Compute check digit and assemble it to a valid number
  def luhnWithComputedCheckDigit(partialCardNumber: String): String = {
    partialCardNumber +
      ((10 - luhnChecksum((partialCardNumber.toLong * 10).toString)) % 10).toString
  }

  def luhnChecksum(number: Seq[Char]): Int = {
    require(number.length <= 18, "Luhn code > 18 positions")
    def doubler(digitPair: Seq[Short]) = {
      digitPair.head + (
        if (digitPair.length > 1)
          digitPair.last * 2 - (if (digitPair.last >= 5) 9 else 0)
        else 0)
    }

    number.reverse.map(_.toString.toShort).grouped(2).foldLeft(0)((acc, a) => acc + doubler(a)) % 10
  }

  // Valid number test
  assert(validNumbers.forall(x => luhnChecksum(x) == 0), "Correct number signaled as invalid")
  // Invalid number test
  assert(invalidNumbers.forall(x => luhnChecksum(x) != 0), "Incorrect number signaled as valid")

  // Test Check digit computation, reuse the valid and invalid numbers
  assert((validNumbers ++ invalidNumbers.
    map(s => luhnWithComputedCheckDigit(s.init /*make partial*/))).forall(x => luhnChecksum(x) == 0),
    "Error in computed checkdigit")

  print("Successfully completed without errors.")
}
