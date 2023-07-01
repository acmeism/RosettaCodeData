object Quine {
  def main(args: Array[String]) {
    val q = "\"" * 3
    val c = """object Quine {
  def main(args: Array[String]) {
    val q = "\"" * 3
    val c = %s%s%s
    println(c format (q, c, q))
  }
}"""
    println(c format (q, c, q))
  }
}
