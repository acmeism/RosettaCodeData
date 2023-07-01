import unicode


func isPalindrome(rseq: seq[Rune]): bool =
  ## Return true if a sequence of runes is a palindrome.
  for i in 1..(rseq.len shr 1):
    if rseq[i - 1] != rseq[^i]:
      return false
  result = true


func isPalindrome(str: string; exact = true): bool {.inline.} =
  ## Return true if a UTF-8 string is a palindrome.
  ## If "exact" is false, ignore white spaces and ignore case.

  if exact:
    result = str.toRunes.isPalindrome()
  else:
    var rseq: seq[Rune]
    for rune in str.runes:
      if not rune.isWhiteSpace:
        rseq.add rune.toLower
    result = rseq.isPalindrome()


when isMainModule:

  proc check(s: string) =
    var exact, inexact: bool
    exact = s.isPalindrome()
    if not exact:
      inexact = s.isPalindrome(exact = false)
    let txt = if exact: " is an exact palindrome."
              elif inexact: " is an inexact palindrome."
              else: " is not a palindrome."
    echo '"', s, '"', txt

check "rotor"
check "été"
check "αννα"
check "salÃ las"
check "In girum imus nocte et consumimur igni"
check "Esope reste ici et se repose"
check "This is a palindrom"
