import algorithm, sequtils, sets, strutils

iterator substrings(s: string): string =
  ## Yield the substrings of the given string.
  for istart in 0..s.high:
    for istop in istart..s.high:
      yield s[istart..istop]

func isPalindrome(s: string): bool =
  ## Return true if "s" is a palindrome.
  result = true
  for i in 0..(s.high div 2):
    if s[i] != s[s.high - i]: return false

func cmpPal(s1, s2: string): int =
  ## Compare two palindromes (used for sort).
  result = cmp(s1.len, s2.len)
  if result == 0:
    result = cmp(s1[0], s2[0])

func palindromes(str: string): seq[string] =
  ## Return the sorted list of palindromes contained in "str".
  var palSet: HashSet[string]
  for s in substrings(str):
    if s.isPalindrome: palSet.incl s
  result = sorted(toSeq(palSet), cmpPal)


when isMainModule:

  for n in 100..125:
    echo n, ": ", palindromes($n).mapIt(it.align(3)).join(" ")

  echo()
  for s in ["9", "169", "12769", "1238769", "123498769", "12346098769",
            "1234572098769", "123456832098769", "12345679432098769",
            "1234567905432098769", "123456790165432098769",
            "83071934127905179083", "1320267947849490361205695"]:
    let pals2 = palindromes(s).filterIt(it.len >= 2)
    let verb = if pals2.len == 0: " doesn't contain palindromes "
              else: " contains at least one palindrome "
    echo s, verb, "of two digits or more"
