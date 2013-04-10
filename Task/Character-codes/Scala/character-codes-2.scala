def charToInt(c: Char, next: Char): Option[Int] = (c, next) match {
  case _ if (c.isHighSurrogate && next.isLowSurrogate) => Some(java.lang.Character.toCodePoint(c, next))
  case _ if (c.isLowSurrogate) => None
  case _ => Some(c.toInt)
}

def intToChars(n: Int): Array[Char] = java.lang.Character.toChars(n)
