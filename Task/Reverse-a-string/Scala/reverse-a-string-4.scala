def reverseString(s: String) = {
  import java.lang.Character._

  val combiningTypes = List(NON_SPACING_MARK, ENCLOSING_MARK, COMBINING_SPACING_MARK)
  def isCombiningCharacter(c: Char) = combiningTypes contains c.getType
  def isCombiningSurrogate(high: Char, low: Char) = combiningTypes contains getType(toCodePoint(high, low))
  def isCombining(l: List[Char]) = l match {
    case List(a, b) => isCombiningSurrogate(a, b)
    case List(a) => isCombiningCharacter(a)
    case Nil => true
    case _ => throw new IllegalArgumentException("isCombining expects a list of up to two characters")
  }

  def cleanSurrogate(l: List[Char]) = l match {
    case List(a, b) if a.isHighSurrogate && b.isLowSurrogate => l
    case List(a, b) if a.isLowSurrogate => Nil
    case List(a, b) => List(a)
    case _ => throw new IllegalArgumentException("cleanSurrogate expects lists of two characters, exactly")
  }

  def splitString(string: String) = (string+" ").iterator sliding 2 map (_.toList) map cleanSurrogate toList

  def recurse(fwd: List[List[Char]], rev: List[Char]): String = fwd match {
    case Nil => rev.mkString
    case c :: rest =>
      val (combining, remaining) = rest span isCombining
      recurse(remaining, c ::: combining.foldLeft(List[Char]())(_ ::: _) ::: rev)
  }
  recurse(splitString(s), Nil)
}
