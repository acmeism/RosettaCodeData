func allEqual(s: openArray[string]): bool =

  for i in 1..s.high:
    if s[i] != s[0]:
      return false
  result = true

func ascending(s: openArray[string]): bool =

  for i in 1..s.high:
    if s[i] <= s[i - 1]:
      return false
  result = true

doAssert allEqual(["abc", "abc", "abc"])
doAssert not allEqual(["abc", "abd", "abc"])

doAssert ascending(["abc", "abd", "abe"])
doAssert not ascending(["abc", "abe", "abd"])

doAssert allEqual(["abc"])
doAssert ascending(["abc"])
