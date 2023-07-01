object StraddlingCheckerboard extends App {

  private val dictonary = Map("H" -> "0", "O" -> "1",
    "L" -> "2", "M" -> "4", "E" -> "5", "S" -> "6", "R" -> "8", "T" -> "9",
    "A" -> "30", "B" -> "31", "C" -> "32", "D" -> "33", "F" -> "34", "G" -> "35",
    "I" -> "36", "J" -> "37", "K" -> "38", "N" -> "39", "P" -> "70", "Q" -> "71",
    "U" -> "72", "V" -> "73", "W" -> "74", "X" -> "75", "Y" -> "76", "Z" -> "77",
    "." -> "78", "/" -> "79", "0" -> "790", "1" -> "791", "2" -> "792", "3" -> "793",
    "4" -> "794", "5" -> "795", "6" -> "796", "7" -> "797", "8" -> "798", "9" -> "799")

  private def encode(s: String) =
    s.toUpperCase.map { case ch: Char => dictonary.getOrElse(ch.toString, "") }.mkString

  private def decode(s: String) = {
    val revDictionary: Map[String, String] = dictonary.map {case (k, v) => (v, k)}

    val pat = "(79.|3.|7.|.)".r
    pat.findAllIn(s).map { el => revDictionary.getOrElse(el, "")}.addString(new StringBuilder)
  }

  val enc = encode(
    "One night-it was on the twentieth of March, " + "1888-I was returning"
  )
  println(enc)
  println(decode(enc))
}
