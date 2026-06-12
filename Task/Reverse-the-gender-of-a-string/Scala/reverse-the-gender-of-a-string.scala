object RevGender extends App {
  val s = "She was a soul stripper. She took my heart!"
  println(cheapTrick(s))
  println(cheapTrick(cheapTrick(s)))

  def cheapTrick(s: String): String = s match {
    case _: String if s.toLowerCase.contains("she") => s.replaceAll("She", "He")
    case _: String if s.toLowerCase.contains("he")  => s.replaceAll("He", "She")
    case _: String                                  => s
  }

}
