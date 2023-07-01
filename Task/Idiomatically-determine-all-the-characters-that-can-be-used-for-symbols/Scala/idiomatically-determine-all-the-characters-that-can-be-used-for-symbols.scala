object IdiomaticallyDetermineSymbols extends App {

  private def print(msg: String, limit: Int, p: Int => Boolean, fmt: String) =
    println(msg + (0 to 0x10FFFF).filter(p).take(limit).map(fmt.format(_)).mkString + "...")

  print("Java Identifier start:    ", 72, cp => Character.isJavaIdentifierStart(cp), "%c")
  print("Java Identifier part:     ", 25, cp => Character.isJavaIdentifierPart(cp), "[%d]")
  print("Identifier ignorable:     ", 25, cp => Character.isIdentifierIgnorable(cp), "[%d]")
  print("Unicode Identifier start: ", 72, cp => Character.isUnicodeIdentifierStart(cp), "%c")
  print("Unicode Identifier part : ", 25, cp => Character.isUnicodeIdentifierPart(cp), "[%d]")

}
