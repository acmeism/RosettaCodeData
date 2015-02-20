def strip3(x: String, s: String = "/*", e: String = "*/"): String = x.indexOf(s) match {
  case -1 => x
  case i => x.indexOf(e, i + s.length) match {
    case -1 => x
    case j => strip2(x.take(i) + x.drop(j + e.length), s, e)
  }
}
