  def isPalindromeSentence(s: String): Boolean =
    (s.size >= 2) && {
      val p = s.replaceAll("[^\\p{L}]", "").toLowerCase
      p == p.reverse
    }
