import Foundation

func countSubstring(str: String, substring: String) -> Int {
  return str.components(separatedBy: substring).count - 1
}

print(countSubstring(str: "the three truths", substring: "th"))
print(countSubstring(str: "ababababab", substring: "abab"))
