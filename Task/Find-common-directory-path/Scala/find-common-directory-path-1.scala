object FindCommonDirectoryPath extends App {
  def commonPath(paths: List[String]): String = {
    def common(a: List[String], b: List[String]): List[String] = (a, b) match {
      case (a :: as, b :: bs) if a equals b => a :: common(as, bs)
      case _ => Nil
    }
    if (paths.length < 2) paths.headOption.getOrElse("")
    else paths.map(_.split("/").toList).reduceLeft(common).mkString("/")
  }

  val test = List(
    "/home/user1/tmp/coverage/test",
    "/home/user1/tmp/covert/operator",
    "/home/user1/tmp/coven/members"
  )
  println(commonPath(test))
}
