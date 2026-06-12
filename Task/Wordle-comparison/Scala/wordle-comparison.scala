object WordleComparison extends App {

  case class TwoWords(answer: String, guess: String)
  enum Colour extends Enum[Colour] {
    case GREEN, GREY, YELLOW
  }

  val pairs = List(TwoWords("ALLOW", "LOLLY"), TwoWords("ROBIN", "SONIC"),
    TwoWords("CHANT", "LATTE"), TwoWords("We're", "She's"), TwoWords("NOMAD", "MAMMA"))

  pairs.foreach(pair => println(s"${pair.answer} v ${pair.guess} -> ${wordle(pair.answer, pair.guess)}"))

  def wordle(answer: String, guess: String): List[Colour] = {
    if (answer.length != guess.length) {
      throw new AssertionError("The two words must be of the same length.")
    }

    var answerCopy = answer
    var result = List.fill(guess.length)(Colour.GREY)

    for (i <- guess.indices) {
      if (answer(i) == guess(i)) {
        answerCopy = answerCopy.updated(i, NULL)
        result = result.updated(i, Colour.GREEN)
      }
    }

    for (i <- guess.indices) {
      val index = answerCopy.indexOf(guess(i))
      if (index >= 0 && result(i) != Colour.GREEN) {
        answerCopy = answerCopy.updated(index, NULL)
        result = result.updated(i, Colour.YELLOW)
      }
    }
    result
  }

  val NULL = '\u0000'
}
