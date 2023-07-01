import java.util.regex.Pattern.quote
def strip1(x: String, s: String = "/*", e: String = "*/") =
  x.replaceAll("(?s)"+quote(s)+".*?"+quote(e), "")
