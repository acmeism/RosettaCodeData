import java.lang.Character._; import scala.annotation.tailrec

object CharacterCode extends App {
  def intToChars(n: Int): Array[Char] = java.lang.Character.toChars(n)

  def UnicodeToList(UTFstring: String) = {
    @tailrec
    def inner(str: List[Char], acc: List[String], surrogateHalf: Option[Char]): List[String] = {
      (str, surrogateHalf) match {
        case (Nil, _) => acc
        case (ch :: rest, None) => if (ch.isSurrogate) inner(rest, acc, Some(ch))
        else inner(rest, acc :+ ch.toString, None)
        case (ch :: rest, Some(f)) => inner(rest, (acc :+ (f.toString + ch)), None)
      }
    }
    inner(UTFstring.toList, Nil, None)
  }

  def UnicodeToInt(utf: String) = {
    def charToInt(high: Char, low: Char) =
      { if (isSurrogatePair(high, low)) toCodePoint(high, low) else high.toInt }
    charToInt(utf(0), if (utf.size > 1) utf(1) else 0)
  }

  def UTFtoHexString(utf: String) = { utf.map(ch => f"${ch.toInt}%04X").mkString("\"\\u", "\\u", "\"") }

  def flags(ch: String) = { // Testing Unicode character properties
    (if (ch matches "\\p{M}") "Y" else "N") + (if (ch matches "\\p{Mn}") "Y" else "N")
  }

  val str = '\uFEFF' /*big-endian BOM*/ + "\u0301a" +
    "$áabcde¢£¤¥©ÇßĲĳŁłʒλπक्तु•₠₡₢₣₤₥₦₧₨₩₪₫€₭₮₯₰₱₲₳₴₵℃←→⇒∙⌘☃☹☺☻ア字文𠀀" + intToChars(173733).mkString

  println(s"Example string: $str")
  println("""    | Chr C/C++/Java source  Code Point Hex      Dec Mn Name
		  	!----+ --- ------------------------- ------- -------- -- """.stripMargin('!') + "-" * 27)

  (UnicodeToList(str)).zipWithIndex.map {
    case (coll, nr) =>
      f"$nr%4d: $coll\t${UTFtoHexString(coll)}%27s U+${UnicodeToInt(coll)}%05X" +
        f"${"(" + UnicodeToInt(coll).toString}%8s) ${flags(coll)}  ${getName(coll(0).toInt)} "
  }.foreach(println)
}
