  def isPalindrome(s: String): Boolean = {
    if (s.size < 2) return false
    s == s.reverse
  }
