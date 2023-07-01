def strip2(x: String, s: String = "/*", e: String = "*/"): String = {
  val a = x indexOf s
  val b = x indexOf (e, a + s.length)
  if (a == -1 || b == -1) x
  else strip2(x.take(a) + x.drop(b + e.length), s, e)
}
