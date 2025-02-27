object ISBNValidator:
  private def checkChecksum(isbn: String): Boolean =
    val digits = isbn.map(_.asDigit)
    val checksum = digits.zipWithIndex.map {
      case (digit, idx) =>
        if idx % 2 == 0 then digit
        else digit * 3
    }.sum
    checksum % 10 == 0

  def isValidISBN13(isbn: String): Boolean =
    val cleaned = isbn.filter(_.isDigit)
    cleaned.length == 13 && checkChecksum(cleaned)

@main def main(): Unit =
  def test(isbn: String): Unit =
    val result = ISBNValidator.isValidISBN13(isbn)
    println(s"$isbn: $result")

  List(
    "978-0596528126",
    "978-0596528120",
    "978-1788399081",
    "978-1788399083"
  )
    .foreach(test)
