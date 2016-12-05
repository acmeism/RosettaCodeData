import strutils

iterator tokenize(text, sep): tuple[token: string, isSep: bool] =
  var i, lastMatch = 0
  while i < text.len:
    for j, s in sep:
      if text[i..text.high].startsWith s:
        if i > lastMatch: yield (text[lastMatch .. <i], false)
        yield (s, true)
        lastMatch = i + s.len
        i += s.high
        break
    inc i
  if i > lastMatch: yield (text[lastMatch .. <i], false)

for token, isSep in "a!===b=!=c".tokenize(["==", "!=", "="]):
  if isSep: stdout.write '{',token,'}'
  else:     stdout.write     token
echo ""
