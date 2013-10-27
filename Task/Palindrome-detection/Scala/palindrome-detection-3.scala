  def isPalindromeRec(s: String) = {
    def inner(s: String): Boolean = s match {
      case s if s.length > 1 => (s.head == s.last) && inner(s.tail.init)
      case _                 => true
    }
    if (s.size < 2) false else inner(s)
  }
