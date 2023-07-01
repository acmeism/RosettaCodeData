import scala.annotation.tailrec

  def isPalindromeRec(s: String) = {
    @tailrec
    def inner(s: String): Boolean =
      (s.length <= 1) || (s.head == s.last) && inner(s.tail.init)

    (s.size >= 2) && inner(s)
  }
