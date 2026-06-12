import sequtils, strutils, unicode

func isPalindrome(s: seq[Rune]): bool =
  ## Return true if a sequence of runes is a palindrome.
  for i in 1..(s.len shr 1):
    if s[i - 1] != s[^i]:
      return false
  result = true

func lps(s: string): seq[string] =
  var maxLength = 0
  var list: seq[seq[Rune]]
  let r = s.toRunes
  for first in 0..r.high:
    for last in first..r.high:
      let candidate = r[first..last]
      if candidate.isPalindrome():
        if candidate.len > maxLength:
          list = @[candidate]
          maxLength = candidate.len
        elif candidate.len == maxLength:
          list.add candidate
  if maxLength > 1:
    result = list.mapIt($it)

for str in ["babaccd", "rotator", "several", "palindrome", "piété", "tantôt", "étêté"]:
  let result = lps(str)
  if result.len == 0:
    echo str, " → ", "<no palindromic substring of two of more letters found>"
  else:
    echo str, " → ", result.join(", ")
