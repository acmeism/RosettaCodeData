proc reversed(s: string): string =
  result = newString(s.len)
  for i, c in s:
    result[s.high - i] = c

proc isPalindrome(s: string): bool =
  s == reversed(s)

when isMainModule:
  assert(isPalindrome(""))
  assert(isPalindrome("a"))
  assert(isPalindrome("aa"))
  assert(not isPalindrome("baa"))
  assert(isPalindrome("baab"))
  assert(isPalindrome("ba_ab"))
  assert(not isPalindrome("ba_ ab"))
  assert(isPalindrome("ba _ ab"))
  assert(not isPalindrome("abab"))
