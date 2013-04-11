def isPalindromeSentence(s: String) = { val p = s.replaceAll("[^\\p{L}]", "").toLowerCase; p == p.reverse }
