object NameGame extends App {
  private def printVerse(name: String): Unit = {
    val x = name.toLowerCase.capitalize

    val y = if ("AEIOU" contains x.head) x.toLowerCase else x.tail

    val (b, f, m) = x.head match {
      case 'B' => (y, "f" + y, "m" + y)
      case 'F' => ("b" + y, y, "m" + y)
      case 'M' => ("b" + y, "f" + y, y)
      case _   => ("b" + y, "f" + y, "m" + y)
    }

    printf("%s, %s, bo-%s\n", x, x, b)
    printf("Banana-fana fo-%s\n", f)
    println(s"Fee-fi-mo-$m")
    println(s"$x!\n")
  }

  Stream("gAry", "earl", "Billy", "Felix", "Mary", "Steve").foreach(printVerse)
}
