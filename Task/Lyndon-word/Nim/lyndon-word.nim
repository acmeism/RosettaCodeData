import std/strutils

proc nextWord(n: Positive; w: string; alphabet: string): string =
  result = repeat(w, n div w.len + 1)
  result.setLen(n)
  while result.len > 0 and result[^1] == alphabet[^1]:
    result.setLen(result.len - 1)
  if result.len != 0:
    let lastChar = result[^1]
    let nextCharIndex = alphabet.find(lastChar) + 1
    result[^1] = alphabet[nextCharIndex]

iterator lyndonWords(n: Positive; alphabet: string): string =
  var w = $alphabet[0]
  while w.len <= n:
    yield w
    w = nextWord(n, w, alphabet)
    if w.len == 0: break

for word in lyndonWords(5, "01"):
  echo word
