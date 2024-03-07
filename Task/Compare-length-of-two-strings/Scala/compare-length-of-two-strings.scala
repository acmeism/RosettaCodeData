object Example extends App {
  val strings = Array("abcd", "123456789", "abcdef", "1234567")
  compareAndReportStringsLength(strings)

  def compareAndReportStringsLength(strings: Array[String]): Unit = {
    if (strings.nonEmpty) {
      val Q = '"'
      val hasLength = " has length "
      val predicateMax = " and is the longest string"
      val predicateMin = " and is the shortest string"
      val predicateAve = " and is neither the longest nor the shortest string"

      val sortedStrings = strings.sortBy(-_.length)
      val maxLength = sortedStrings.head.length
      val minLength = sortedStrings.last.length

      sortedStrings.foreach { str =>
        val length = str.length
        val predicate = length match {
          case `maxLength` => predicateMax
          case `minLength` => predicateMin
          case _           => predicateAve
        }
        println(s"$Q$str$Q$hasLength$length$predicate")
      }
    }
  }
}
