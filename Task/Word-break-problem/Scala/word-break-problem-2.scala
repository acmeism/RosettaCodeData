val dict = buildTrie("a", "bc", "abc", "cd", "b")
val testCases = List("abcd", "abbc", "abcbcd", "acdbc", "abcdd")
for (s <- testCases) {
  val solutions = wordBreak(s, dict)
  println(s"$s has ${solutions.size} solution(s):")
  for (words <- solutions) {
    println("\t" + words.mkString(" "))
  }
}
