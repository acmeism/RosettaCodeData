object WordBreak extends App {
  val dict = buildTrie("a", "bc", "abc", "cd", "b")
  lazy val empty = TrieNode(isWord = false, Map.empty) // lazy or in a companion object

  case class TrieNode(isWord: Boolean, children: Map[Char, TrieNode]) {

    def add(s: String): TrieNode = {
      def child = children.withDefaultValue(empty)(s.head)

      if (s.isEmpty) copy(isWord = true)
      else copy(children = children.updated(s.head, child.add(s.tail)))
    }
  }

  def buildTrie(xs: String*): TrieNode = xs.foldLeft(empty)(_.add(_))

  def wordBreak(s: String, dict: TrieNode): List[List[String]] = {

    def wordBreakRec(s: String,
                     root: TrieNode,
                     currentPos: TrieNode,
                     soFar: String): List[List[String]] = {

      def usingCurrentWord =
        if (currentPos.isWord)
          if (s.isEmpty) List(List(soFar))
          else wordBreakRec(s, root, root, "").map(soFar :: _)
        else Nil

      def usingCurrentPrefix =
         (for {ch <- s.headOption
              child <- currentPos.children.get(ch)
        } yield wordBreakRec(s.tail, root, child, soFar + ch))
          .getOrElse(Nil)

      usingCurrentWord ++ usingCurrentPrefix
    }

    wordBreakRec(s, dict, dict, "")
  }

  // Calling it with some example strings:
  List("abcd", "abbc", "abcbcd", "acdbc", "abcdd").foreach(s => {
    val solutions = wordBreak(s, dict)

    println(s"$s has ${solutions.size} solution(s):")
    solutions.foreach(words => println(words.mkString("\t", " ", "")))
  })

}
