// To run execute: odin test Test_a_function.odin -file
package main

import "core:testing"
import "core:strings"

is_palindrome :: proc(s: string) -> bool {
  return s == strings.reverse(s)
}

@(test)
test_is_palindrome :: proc(t: ^testing.T) {
  palindromes := []string{"", "a", "aa", "aba", "racecar"}
  for i in palindromes {
    if !is_palindrome(i) {
      testing.errorf(t, "is_palindrome returned false on palindrome %s", i)
    }
  }

  non_palindromes := []string{"ab", "abaa", "aaba", "abcdba"}
  for i in non_palindromes {
    if is_palindrome(i) {
      testing.errorf(t, "is_palindrome returned true on non-palindrome %s", i)
    }
  }
}
