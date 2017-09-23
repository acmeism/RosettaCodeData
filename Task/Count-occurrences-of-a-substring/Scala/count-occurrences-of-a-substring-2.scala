def countSubstring(str: String, sub: String): Int =
  str.sliding(sub.length).count(_ == sub)
