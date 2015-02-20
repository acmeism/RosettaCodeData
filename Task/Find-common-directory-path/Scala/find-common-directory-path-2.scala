object FindCommonDirectoryPathRelative extends App {
  def commonPath(paths: List[String]): String = {
    val SEP = "/"
    val BOUNDARY_REGEX = s"(?=[$SEP])(?<=[^$SEP])|(?=[^$SEP])(?<=[$SEP])"
    def common(a: List[String], b: List[String]): List[String] = (a, b) match {
      case (a :: as, b :: bs) if a equals b => a :: common(as, bs)
      case _ => Nil
    }
    if (paths.length < 2) paths.headOption.getOrElse("")
    else paths.map(_.split(BOUNDARY_REGEX).toList).reduceLeft(common).mkString
  }

  val test = List(
    "/home/user1/tmp/coverage/test",
    "/home/user1/tmp/covert/operator",
    "/home/user1/tmp/coven/members"
  )
  println(commonPath(test).replaceAll("/$", ""))

  // test cases
  assert(commonPath(test.take(1)) == test.head)
  assert(commonPath(Nil) == "")
  assert(commonPath(List("")) == "")
  assert(commonPath(List("/")) == "/")
  assert(commonPath(List("/", "")) == "")
  assert(commonPath(List("/", "/a")) == "/")
  assert(commonPath(List("/a", "/b")) == "/")
  assert(commonPath(List("/a", "/a")) == "/a")
  assert(commonPath(List("/a/a", "/b")) == "/")
  assert(commonPath(List("/a/a", "/b")) == "/")
  assert(commonPath(List("/a/a", "/a")) == "/a")
  assert(commonPath(List("/a/a", "/a/b")) == "/a/")
  assert(commonPath(List("/a/b", "/a/b")) == "/a/b")
  assert(commonPath(List("a", "/a")) == "")
  assert(commonPath(List("a/a", "/a")) == "")
  assert(commonPath(List("a/a", "/b")) == "")
  assert(commonPath(List("a", "a")) == "a")
  assert(commonPath(List("a/a", "b")) == "")
  assert(commonPath(List("a/a", "b")) == "")
  assert(commonPath(List("a/a", "a")) == "a")
  assert(commonPath(List("a/a", "a/b")) == "a/")
  assert(commonPath(List("a/b", "a/b")) == "a/b")
  assert(commonPath(List("/a/", "/b/")) == "/")
  assert(commonPath(List("/a/", "/a/")) == "/a/")
  assert(commonPath(List("/a/a/", "/b/")) == "/")
  assert(commonPath(List("/a/a/", "/b/")) == "/")
  assert(commonPath(List("/a/a/", "/a/")) == "/a/")
  assert(commonPath(List("/a/a/", "/a/b/")) == "/a/")
  assert(commonPath(List("/a/b/", "/a/b/")) == "/a/b/")
}
