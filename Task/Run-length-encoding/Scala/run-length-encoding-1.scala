def encode(s: String) = (1 until s.size).foldLeft((1, s(0), new StringBuilder)) {
  case ((len, c, sb), index) if c != s(index) => sb.append(len); sb.append(c); (1, s(index), sb)
  case ((len, c, sb), _) => (len + 1, c, sb)
} match {
  case (len, c, sb) => sb.append(len); sb.append(c); sb.toString
}

def decode(s: String) = {
  val sb = new StringBuilder
  val Code = """(\d+)([A-Z])""".r
  for (Code(len, c) <- Code findAllIn s) sb.append(c * len.toInt)
  sb.toString
}
