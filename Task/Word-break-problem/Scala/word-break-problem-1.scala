case class TrieNode(isWord: Boolean, children: Map[Char, TrieNode]) {
  def add(s: String): TrieNode = s match {
    case "" => copy(isWord = true)
    case _ => {
      val child = children.getOrElse(s.head, TrieNode(false, Map.empty))
      copy(children = children + (s.head -> child.add(s.tail)))
    }
  }
}

def buildTrie(xs: String*): TrieNode = {
  xs.foldLeft(TrieNode(false, Map.empty))(_.add(_))
}

def wordBreakRec(s: String, root: TrieNode, currentPos: TrieNode, soFar: String): List[List[String]] = {
  val usingCurrentWord = if (currentPos.isWord) {
    if (s.isEmpty) {
      List(List(soFar))
    } else {
      wordBreakRec(s, root, root, "").map(soFar :: _)
    }
  } else {
    List.empty[List[String]]
  }
  val usingCurrentPrefix = (for {
    ch <- s.headOption
    child <- currentPos.children.get(ch)
  } yield wordBreakRec(s.tail, root, child, soFar + ch)).getOrElse(List.empty)
  usingCurrentWord ++ usingCurrentPrefix
}

def wordBreak(s: String, dict: TrieNode): List[List[String]] = {
  wordBreakRec(s, dict, dict, "")
}
