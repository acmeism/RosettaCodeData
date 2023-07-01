import sequtils

func allEqual(s: openArray[string]): bool =
  allIt(s, it == s[0])

doAssert allEqual(["abc", "abc", "abc"])
doAssert not allEqual(["abc", "abd", "abc"])
doAssert allEqual(["abc"])
