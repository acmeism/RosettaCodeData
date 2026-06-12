import std/strutils

proc chenFoxLyndonFactorization*(s: string): seq[string] =
  ## Duval’s algorithm.
  let n = s.len
  var i = 0
  while i < n:
    var (j, k) = (i + 1, i)
    while j < n and s[k] <= s[j]:
      k = if s[k] < s[j]: i else: k + 1
      inc j
    while i <= k:
      result.add s[i..<(i + j - k)]
      inc i, j - k
  assert result.join() == s

when isMainModule:
  # Example use with Thue-Morse sequence.
  var m = "0"
  for _ in 0..6:
    m &= m.replace('0', 'a').replace('1', '0').replace('a', '1')
  echo chenFoxLyndonFactorization(m)
