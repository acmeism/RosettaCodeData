import unittest

proc reverse(s): string =
  result = newString(s.len)
  for i,c in s:
    result[s.high - i] = c

proc isPalindrome(s): bool =
  s == reverse(s)

when isMainModule:
  suite "palindrome":
    test "empty string":
      check isPalindrome ""

    test "string of length 1":
      check isPalindrome "a"

    test "string of length 2":
      check isPalindrome "aa"

    test "string of length 3":
      check isPalindrome "aaa"

    test "no palindrome":
      check isPalindrome("foo") == false
