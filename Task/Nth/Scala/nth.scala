object Nth extends App {
  def abbrevNumber(i: Int) = print(s"$i${ordinalAbbrev(i)} ")

  def ordinalAbbrev(n: Int) = {
    val ans = "th" //most of the time it should be "th"
    if (n % 100 / 10 == 1) ans //teens are all "th"
    else (n % 10) match {
      case 1 => "st"
      case 2 => "nd"
      case 3 => "rd"
      case _ => ans
    }
  }

  (0 to 25).foreach(abbrevNumber)
  println()
  (250 to 265).foreach(abbrevNumber)
  println();
  (1000 to 1025).foreach(abbrevNumber)
}
