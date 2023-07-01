object Compare extends App {
  def compare(a: String, b: String) {
    if (a == b) println(s"'$a' and '$b' are lexically equal.")
    else println(s"'$a' and '$b' are not lexically equal.")

    if (a.equalsIgnoreCase(b)) println(s"'$a' and '$b' are case-insensitive lexically equal.")
    else println(s"'$a' and '$b' are not case-insensitive lexically equal.")

    if (a.compareTo(b) < 0) println(s"'$a' is lexically before '$b'.")
    else if (a.compareTo(b) > 0) println(s"'$a' is lexically after '$b'.")

    if (a.compareTo(b) >= 0) println(s"'$a' is not lexically before '$b'.")
    if (a.compareTo(b) <= 0) println(s"'$a' is not lexically after '$b'.")

    println(s"The lexical relationship is: ${a.compareTo(b)}")
    println(s"The case-insensitive lexical relationship is: ${a.compareToIgnoreCase(b)}\n")
  }

  compare("Hello", "Hello")
  compare("5", "5.0")
  compare("java", "Java")
  compare("ĴÃVÁ", "ĴÃVÁ")
  compare("ĴÃVÁ", "ĵãvá")
}
