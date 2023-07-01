object Main extends App {
  val a = Seq(1, 2, 3, 4, 5)
  println(s"Array       : ${a.mkString(", ")}")
  println(s"Sum         : ${a.sum}")
  println(s"Difference  : ${a.reduce { (x, y) => x - y }}")
  println(s"Product     : ${a.product}")
  println(s"Minimum     : ${a.min}")
  println(s"Maximum     : ${a.max}")
}
