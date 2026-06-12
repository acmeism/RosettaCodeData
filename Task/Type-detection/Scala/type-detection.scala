object TypeDetection extends App {
  def showType(a: Any) = a match {
    case a: Int => println(s"'$a' is an integer")
    case a: Double => println(s"'$a' is a double")
    case a: Char => println(s"'$a' is a character")
    case _ => println(s"'$a' is some other type")
  }

  showType(5)
  showType(7.5)
  showType('d')
  showType(true)

  println(s"\nSuccessfully completed without errors. [total ${scala.compat.Platform.currentTime - executionStart} ms]")

}
