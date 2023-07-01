def printSierpinski(n: Int) {
  def sierpinski(n: Int): List[String] = {
    lazy val down = sierpinski(n - 1)
    lazy val space = " " * (1 << (n - 1))
    n match {
      case 0 => List("*")
      case _ => (down map (space + _ + space)) :::
                (down map (List.fill(2)(_) mkString " "))
    }
  }
  sierpinski(n) foreach println
}
