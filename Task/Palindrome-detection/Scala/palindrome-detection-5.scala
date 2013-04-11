def isPalindrome(s : String) : Boolean = s match {
  case s if s.length > 1 => (s.head == s.last) && isPalindrome(s.slice(1, s.length-1))
  case _ => true
}
