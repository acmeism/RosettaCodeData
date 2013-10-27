  def isPalindromeSentence(s: String): Boolean = {
    if (s.size < 2) return false
    val p = s.replaceAll("[^\\p{L}]", "").toLowerCase;
    p == p.reverse
  }
